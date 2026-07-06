--[[
The first rule is what decides whether plugins load or `--clean` is forced:

- With explicit file or directory arguments, those target directories decide the
  mode. Only targets under visible top-level directories inside `$HOME` keep the
  normal bubblewrapped Neovim with plugins. Anything else forces bubblewrapped
  `nvim --clean`: hidden top-level directories under `$HOME`, `$HOME` itself,
  and any target outside `$HOME`.
- Without explicit targets, the current working directory decides the mode by
  the same rule. A visible top-level directory under `$HOME` keeps plugins;
  anything else forces bubblewrapped `nvim --clean`.

This launcher always tries to run Neovim inside bubblewrap. Wayland support is
optional: when `XDG_RUNTIME_DIR`, `WAYLAND_DISPLAY`, and the live socket are all
available, they are bound into the sandbox for clipboard and GUI integration.
When they are missing, Neovim still launches inside bubblewrap, just without the
Wayland socket.

Inside the sandbox, Neovim can still work on the current workspace, or on the
git repo root when launched from inside a checkout. Git worktrees are supported:
if the shared git directory lives outside the worktree, that location is bound
in too. File arguments outside the workspace are only bound in when they pass
the safe-target rule above.

The bubblewrapped Neovim still supports the things this config needs in normal
use: the Neovim config itself, plugin/state/cache directories, the Nix store and
system paths, optional Wayland clipboard access through the live socket, SSH
config plus an optional SSH agent socket, `.venv/bin` on PATH, and temporary
files under `/tmp`. When the target location looks unsafe, the launcher keeps
the sandbox but forces `--clean` so plugins do not load.
]]

local extra_path = os.getenv("NVIM_BWRAP_LUA_PATH")
if extra_path ~= nil and extra_path ~= "" then
  package.path = extra_path .. ";" .. package.path
end

local nvim_bwrap = require("myconfig.nvim_bwrap")

-- Lua 5.1 here has no convenient structured process API, so host-side probes
-- are done with tiny shell commands while the main control flow stays in Lua.
local function shell_quote(text)
  return "'" .. tostring(text):gsub("'", [["'"']]) .. "'"
end

local function shell_join(parts)
  local quoted = {}
  for i, part in ipairs(parts) do
    quoted[i] = shell_quote(part)
  end
  return table.concat(quoted, " ")
end

local function normalize_execute_result(ok, why, code)
  if type(ok) == "number" then
    return ok == 0, ok
  end

  if ok == true then
    return true, 0
  end

  if why == "exit" and type(code) == "number" then
    return code == 0, code
  end

  if why == "signal" and type(code) == "number" then
    return false, 128 + code
  end

  return false, 1
end

local function run_command(parts)
  local ok, why, code = os.execute(shell_join(parts))
  return normalize_execute_result(ok, why, code)
end

local function capture_command(parts)
  local handle = assert(io.popen(shell_join(parts) .. " 2>/dev/null", "r"))
  local output = handle:read("*a")
  local ok, why, code = handle:close()
  local success = normalize_execute_result(ok, why, code)

  if not success then
    return nil
  end

  output = output:gsub("%s+$", "")
  if output == "" then
    return nil
  end

  return output
end

local function file_exists(path)
  local success = run_command({"test", "-e", path})
  return success
end

local function socket_exists(path)
  local success = run_command({"test", "-S", path})
  return success
end

local function pwd_physical(path)
  return assert(capture_command({"sh", "-c", "cd -- \"$1\" && pwd -P", "sh", path}), "failed to resolve path " .. path)
end

local function realpath_m(path)
  return assert(capture_command({"realpath", "-m", "--", path}), "failed to resolve realpath for " .. path)
end

local function dirname(path)
  return assert(capture_command({"dirname", "--", path}), "failed to resolve dirname for " .. path)
end

local function starts_with(text, prefix)
  return text:sub(1, #prefix) == prefix
end

local function append_all(dst, src)
  for _, value in ipairs(src) do
    dst[#dst + 1] = value
  end
end

local function add_bind_args(dst, flag, source, target)
  dst[#dst + 1] = flag
  dst[#dst + 1] = source
  dst[#dst + 1] = target
end

local function set_env(dst, key, value)
  dst[#dst + 1] = "--setenv"
  dst[#dst + 1] = key
  dst[#dst + 1] = value
end

local function run_or_exit(parts)
  local success, code = run_command(parts)
  os.exit(success and 0 or code)
end

local home = assert(os.getenv("HOME"), "HOME must be set")
local bwrap_bin = assert(os.getenv("NVIM_BWRAP_BWRAP_BIN"), "NVIM_BWRAP_BWRAP_BIN must be set")
local neovim_bin = assert(os.getenv("NVIM_BWRAP_NEOVIM_BIN"), "NVIM_BWRAP_NEOVIM_BIN must be set")
local repo_root = assert(os.getenv("NVIM_BWRAP_REPO_ROOT"), "NVIM_BWRAP_REPO_ROOT must be set")
local sandboxed_ssh_bin = assert(os.getenv("NVIM_BWRAP_SANDBOXED_SSH_BIN"), "NVIM_BWRAP_SANDBOXED_SSH_BIN must be set")
local xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR")
local wayland_display = os.getenv("WAYLAND_DISPLAY")
local wayland_socket = nil

-- Nix build-time invocations do not have the live checkout available at
-- `repo_root`, but they still need a working `nvim` binary for manifest
-- generation. In that case, skip the sandbox launcher entirely.
if not file_exists(repo_root) then
  local fallback = {neovim_bin}
  for i = 1, #arg do
    fallback[#fallback + 1] = arg[i]
  end
  run_or_exit(fallback)
end

local home_dir = pwd_physical(home)
local cwd = assert(capture_command({"pwd", "-P"}), "failed to resolve cwd")
local workspace = cwd
local extra_workspace_binds = {}
local extra_target_binds = {}
local ssh_auth_sock_binds = {}
local ssh_auth_sock_env = {}

-- If we are somewhere inside a git checkout, expose the full repo root. For
-- git worktrees, the shared git dir may live elsewhere and needs its own bind.
local git_root = capture_command({"git", "-C", cwd, "rev-parse", "--show-toplevel"})
if git_root ~= nil then
  workspace = pwd_physical(git_root)

  local git_common_dir = capture_command({"git", "-C", cwd, "rev-parse", "--path-format=absolute", "--git-common-dir"})
  if git_common_dir ~= nil then
    git_common_dir = pwd_physical(git_common_dir)
    local git_repo_location = git_common_dir

    if starts_with(git_common_dir, "/") and git_common_dir:sub(-5) == "/.git" then
      git_repo_location = dirname(git_common_dir)
    end

    if git_repo_location ~= workspace then
      add_bind_args(extra_workspace_binds, "--bind", git_repo_location, git_repo_location)
    end
  end
end

if xdg_runtime_dir ~= nil and xdg_runtime_dir ~= "" and wayland_display ~= nil and wayland_display ~= "" then
  local candidate_wayland_socket = xdg_runtime_dir .. "/" .. wayland_display
  if socket_exists(candidate_wayland_socket) then
    wayland_socket = candidate_wayland_socket
  end
end

local ssh_auth_sock = os.getenv("SSH_AUTH_SOCK")
if ssh_auth_sock ~= nil and ssh_auth_sock ~= "" and socket_exists(ssh_auth_sock) then
  add_bind_args(ssh_auth_sock_binds, "--bind", ssh_auth_sock, ssh_auth_sock)
  set_env(ssh_auth_sock_env, "SSH_AUTH_SOCK", ssh_auth_sock)
end

-- The policy layer only cares about directories, so file arguments are reduced
-- to the directories that must be visible inside the sandbox.
local explicit_target_dirs = {}
for i = 1, #arg do
  local value = arg[i]
  if value ~= "" and not starts_with(value, "-") and not starts_with(value, "+") and not value:match("^[%a][%w+.-]*://") then
    local target_path
    if file_exists(value) then
      target_path = realpath_m(value)
    else
      target_path = realpath_m(dirname(value))
    end

    local target_dir = target_path
    if not run_command({"test", "-d", target_path}) then
      target_dir = dirname(target_path)
    end

    explicit_target_dirs[#explicit_target_dirs + 1] = target_dir
  end
end

-- `decide` is the pure part: should plugins be disabled, and which extra
-- directories are safe enough to bind in addition to the workspace?
local decision = nvim_bwrap.decide({
  workspace = workspace,
  cwd = cwd,
  home_dir = home_dir,
  explicit_target_dirs = explicit_target_dirs,
})

for _, bind_dir in ipairs(decision.bind_dirs) do
  add_bind_args(extra_target_binds, "--bind", bind_dir, bind_dir)
end

local nvim_args = {}
if decision.clean then
  nvim_args[#nvim_args + 1] = "--clean"
end
for i = 1, #arg do
  nvim_args[#nvim_args + 1] = arg[i]
end

-- Start with the always-needed mounts, then append the optional pieces
-- discovered above.
local bwrap_args = {
  bwrap_bin,
  "--dev", "/dev",
  "--proc", "/proc",
  "--ro-bind", "/lib64", "/lib64",
  "--ro-bind", "/nix/store", "/nix/store",
  "--ro-bind", "/run/current-system", "/run/current-system",
  "--ro-bind", "/etc", "/etc",
  "--ro-bind", repo_root, repo_root,
  "--ro-bind", home .. "/.nix-profile", home .. "/.nix-profile",
  "--dir", home .. "/.ssh",
  "--ro-bind", home .. "/.config/nvim", home .. "/.config/nvim",
  "--bind", workspace, workspace,
}

if xdg_runtime_dir ~= nil and xdg_runtime_dir ~= "" then
  bwrap_args[#bwrap_args + 1] = "--dir"
  bwrap_args[#bwrap_args + 1] = xdg_runtime_dir
end

if wayland_socket ~= nil then
  add_bind_args(bwrap_args, "--ro-bind", wayland_socket, wayland_socket)
end

append_all(bwrap_args, extra_workspace_binds)
append_all(bwrap_args, extra_target_binds)
append_all(bwrap_args, ssh_auth_sock_binds)
append_all(bwrap_args, {
  "--bind", home .. "/.local/share/nvim", home .. "/.local/share/nvim",
  "--bind", home .. "/.local/state/nvim", home .. "/.local/state/nvim",
  "--bind-try", home .. "/.cache/nvim", home .. "/.cache/nvim",
  "--bind-try", home .. "/.cache/uv", home .. "/.cache/uv",
  "--bind-try", home .. "/.codex", home .. "/.codex",
  "--ro-bind-try", home .. "/.ssh/config", home .. "/.ssh/config",
  "--ro-bind-try", home .. "/.ssh/known_hosts", home .. "/.ssh/known_hosts",
  "--ro-bind-try", home .. "/.ssh/known_hosts2", home .. "/.ssh/known_hosts2",
})

set_env(bwrap_args, "VIRTUAL_ENV", cwd .. "/.venv")
set_env(bwrap_args, "TMPDIR", "/tmp")
set_env(bwrap_args, "TMP", "/tmp")
set_env(bwrap_args, "TEMP", "/tmp")
set_env(bwrap_args, "HOME", home)
if xdg_runtime_dir ~= nil and xdg_runtime_dir ~= "" then
  set_env(bwrap_args, "XDG_RUNTIME_DIR", xdg_runtime_dir)
end
if wayland_display ~= nil and wayland_display ~= "" then
  set_env(bwrap_args, "WAYLAND_DISPLAY", wayland_display)
end
append_all(bwrap_args, ssh_auth_sock_env)
local inherited_path = os.getenv("PATH") or ""
local sandbox_path = cwd .. "/.venv/bin:" .. dirname(sandboxed_ssh_bin)
if inherited_path ~= "" then
  sandbox_path = sandbox_path .. ":" .. inherited_path
else
  sandbox_path = sandbox_path .. ":" .. home .. "/.nix-profile/bin:/run/current-system/sw/bin"
end
set_env(
  bwrap_args,
  "PATH",
  sandbox_path
)

append_all(bwrap_args, {
  "--chdir", cwd,
  "--tmpfs", "/tmp",
  neovim_bin,
})
append_all(bwrap_args, nvim_args)

run_or_exit(bwrap_args)
