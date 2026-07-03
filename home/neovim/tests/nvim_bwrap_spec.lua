-- These tests cover the pure policy module only. They do not run bubblewrap or
-- spawn the launcher; they verify the clean-mode and extra-bind decisions that
-- the launcher consumes.

local extra_path = os.getenv("NVIM_BWRAP_LUA_PATH")
if extra_path ~= nil and extra_path ~= "" then
  package.path = extra_path .. ";" .. package.path
end

local nvim_bwrap = require("myconfig.nvim_bwrap")

local function assert_eq(actual, expected, message)
  if actual ~= expected then
    error(string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
  end
end

local function assert_list_eq(actual, expected, message)
  assert_eq(#actual, #expected, message .. " length")
  for i = 1, #expected do
    assert_eq(actual[i], expected[i], string.format("%s item %d", message, i))
  end
end

local function run_test(name, fn)
  io.write("test ", name, "\n")
  fn()
end

-- A safe explicit target should override an unsafe cwd, because the user is
-- clearly asking to open something in a visible project directory.
run_test("safe explicit target adds bind and keeps plugins", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/.hidden",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {"/home/lobo/projects/ml2"},
  })

  assert_eq(decision.clean, false, "safe explicit target should not force clean mode")
  assert_list_eq(decision.bind_dirs, {"/home/lobo/projects/ml2"}, "safe explicit target should be bound")
end)

-- Hidden top-level home directories remain unsafe even when they are named
-- explicitly.
run_test("unsafe explicit target forces clean mode", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/projects/nix",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {"/home/lobo/.dvc"},
  })

  assert_eq(decision.clean, true, "unsafe explicit target should force clean mode")
  assert_list_eq(decision.bind_dirs, {"/home/lobo/.dvc"}, "unsafe explicit target should still be bound")
end)

-- Anything outside HOME is treated as unsafe too. Only visible top-level HOME
-- directories keep the full plugin-loaded mode.
run_test("explicit target outside home forces clean mode", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/projects/nix",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {"/tmp/demo"},
  })

  assert_eq(decision.clean, true, "target outside home should force clean mode")
  assert_list_eq(decision.bind_dirs, {"/tmp/demo"}, "target outside home should still be bound")
end)

-- Clean mode is contagious across explicit targets, but safe targets should
-- still be available inside the sandbox, and the explicitly requested unsafe
-- target must be mounted too so Neovim can open it.
run_test("mixed explicit targets still bind safe directories", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/projects/nix",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {"/home/lobo/projects/ml2", "/home/lobo/.dvc"},
  })

  assert_eq(decision.clean, true, "any unsafe explicit target should force clean mode")
  assert_list_eq(
    decision.bind_dirs,
    {"/home/lobo/projects/ml2", "/home/lobo/.dvc"},
    "all explicit targets should still be bound"
  )
end)

-- Once explicit targets exist, the cwd is no longer the deciding signal.
run_test("unsafe cwd is ignored when explicit targets exist", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/.hidden",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {"/home/lobo/projects/ml2"},
  })

  assert_eq(decision.clean, false, "explicit targets should replace cwd for clean-mode decisions")
end)

-- A target already underneath the workspace is covered by the workspace bind.
run_test("workspace descendants are not rebound", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/projects/nix",
    workspace = "/home/lobo/projects",
    explicit_target_dirs = {"/home/lobo/projects/ml2"},
  })

  assert_eq(decision.clean, false, "safe workspace descendant should not force clean mode")
  assert_list_eq(decision.bind_dirs, {}, "workspace descendants should not be rebound")
end)

-- Without explicit targets, an unsafe cwd still falls back to plugin-free mode.
run_test("unsafe cwd without explicit targets still forces clean mode", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/home/lobo/.hidden",
    workspace = "/home/lobo/projects/nix",
    explicit_target_dirs = {},
  })

  assert_eq(decision.clean, true, "unsafe cwd should still force clean mode without explicit targets")
end)

run_test("cwd outside home without explicit targets forces clean mode", function()
  local decision = nvim_bwrap.decide({
    home_dir = "/home/lobo",
    cwd = "/tmp/demo",
    workspace = "/tmp/demo",
    explicit_target_dirs = {},
  })

  assert_eq(decision.clean, true, "cwd outside home should force clean mode without explicit targets")
end)

io.write("ok\n")
