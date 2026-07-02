{
  pkgs,
  globals,
  config,
  lib,
  ...
}: let
  mkGitSymlink = git_path: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${git_path}");
  homePrefix = "/home/${globals.username}";
  repoRoot =
    if lib.hasPrefix homePrefix globals.nixos_git_root
    then "${config.home.homeDirectory}${lib.removePrefix homePrefix globals.nixos_git_root}"
    else globals.nixos_git_root;

  /* 
  Inside the Neovim bubblewrap, OpenSSH's default /etc/ssh/ssh_config path can fail
  ownership checks on Nix store includes, so force ssh to start from the user config.
  */
  sandboxedSshBin = pkgs.writeShellScriptBin "ssh" ''
    set -euo pipefail

    if [[ -r "$HOME/.ssh/config" ]]; then
      exec ${pkgs.openssh}/bin/ssh -F "$HOME/.ssh/config" "$@"
    fi

    exec ${pkgs.openssh}/bin/ssh \
      -F /dev/null \
      -o GlobalKnownHostsFile=/etc/ssh/ssh_known_hosts \
      -o ForwardX11=no \
      "$@"
  '';

  /*
  Bubble wrapped version of Neovim that binds the current workspace plus the directories
  needed for neovim to function. 

  The workspace is the current working directory unless it is inside a git repository, 
  in which case the git repo root is bound instead. For git worktrees, the backing shared 
  git directory is also bound when it lives elsewhere on disk.

  If the current working directory is not a visible directory within the home directory 
  (i.e. a dot directory or directory outside of $HOME) then Neovim will launch without 
  plugins to be safe (--clean).

  ssh remote access is given to Neovim so I can sync-remote my workspace to another machine. 
  Neovim does not have access to my keys though, only my ssh socket and config.

  Some wayland support is given to neovim, so I can copy to the clipboard.
  */
  nvimBwrapLauncher = pkgs.writeShellScript "nvim-bwrap-launcher" ''
    set -euo pipefail

    : "''${HOME:?HOME must be set}"

    # these lines are only here to support nix build
    if [[ -z "''${XDG_RUNTIME_DIR:-}" || -z "''${WAYLAND_DISPLAY:-}" ]]; then
      exec ${pkgs.neovim-unwrapped}/bin/nvim --clean "$@"
    fi

    repo_root=${lib.escapeShellArg repoRoot}
    home_dir="$(cd -- "$HOME" && pwd -P)"
    cwd="$(pwd -P)"
    workspace="$cwd"
    extra_workspace_bind=()
    ssh_auth_sock_bind=()
    ssh_auth_sock_env=()

    if git_root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)"; then
      workspace="$(cd -- "$git_root" && pwd -P)"

      if git_common_dir="$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then
        git_common_dir="$(cd -- "$git_common_dir" && pwd -P)"
        git_repo_location="$git_common_dir"

        if [[ "$git_common_dir" == */.git ]]; then
          git_repo_location="$(dirname -- "$git_common_dir")"
        fi

        if [[ "$git_repo_location" != "$workspace" ]]; then
          extra_workspace_bind=(--bind "$git_repo_location" "$git_repo_location")
        fi
      fi
    fi

    is_safe_cwd() {
      local path="$1"
      local rel_path
      local top_level_dir

      if [[ "$path" == "$home_dir" ]]; then
        return 1
      fi

      if [[ "$path" == "$home_dir"/* ]]; then
        rel_path="''${path#$home_dir/}"
        top_level_dir="''${rel_path%%/*}"
        [[ "$top_level_dir" != .* ]]
        return
      fi

      return 0
    }

    if [[ ! -S "''${XDG_RUNTIME_DIR}/''${WAYLAND_DISPLAY}" ]]; then
      printf 'Wayland socket not found: %s\n' "''${XDG_RUNTIME_DIR}/''${WAYLAND_DISPLAY}" >&2
      exit 1
    fi

    if [[ -n "''${SSH_AUTH_SOCK:-}" && -S "''${SSH_AUTH_SOCK}" ]]; then
      ssh_auth_sock_bind=(--bind "''${SSH_AUTH_SOCK}" "''${SSH_AUTH_SOCK}")
      ssh_auth_sock_env=(--setenv SSH_AUTH_SOCK "''${SSH_AUTH_SOCK}")
    fi

    nvim_args=("$@")
    if ! is_safe_cwd "$cwd"; then
      nvim_args=(--clean "$@")
    fi

    exec ${pkgs.bubblewrap}/bin/bwrap \
      --dev /dev \
      --proc /proc \
      --ro-bind /lib64 /lib64 \
      --ro-bind /nix/store /nix/store \
      --ro-bind /run/current-system /run/current-system \
      --ro-bind /etc /etc \
      --ro-bind "$repo_root" "$repo_root" \
      --ro-bind "$HOME/.nix-profile" "$HOME/.nix-profile" \
      --dir "$XDG_RUNTIME_DIR" \
      --dir "$HOME/.ssh" \
      --ro-bind "''${XDG_RUNTIME_DIR}/''${WAYLAND_DISPLAY}" "''${XDG_RUNTIME_DIR}/''${WAYLAND_DISPLAY}" \
      --ro-bind "$HOME/.config/nvim" "$HOME/.config/nvim" \
      --bind "$workspace" "$workspace" \
      "''${extra_workspace_bind[@]}" \
      "''${ssh_auth_sock_bind[@]}" \
      --bind "$HOME/.local/share/nvim" "$HOME/.local/share/nvim" \
      --bind "$HOME/.local/state/nvim" "$HOME/.local/state/nvim" \
      --bind-try "$HOME/.cache/nvim" "$HOME/.cache/nvim" \
      --bind-try "$HOME/.cache/uv" "$HOME/.cache/uv" \
      --bind-try "$HOME/.codex" "$HOME/.codex" \
      --ro-bind-try "$HOME/.ssh/config" "$HOME/.ssh/config" \
      --ro-bind-try "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts" \
      --ro-bind-try "$HOME/.ssh/known_hosts2" "$HOME/.ssh/known_hosts2" \
      --setenv VIRTUAL_ENV "$cwd/.venv" \
      --setenv TMPDIR /tmp \
      --setenv TMP /tmp \
      --setenv TEMP /tmp \
      --setenv HOME "$HOME" \
      --setenv XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR" \
      --setenv WAYLAND_DISPLAY "$WAYLAND_DISPLAY" \
      "''${ssh_auth_sock_env[@]}" \
      --setenv PATH "$cwd/.venv/bin:${sandboxedSshBin}/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin" \
      --chdir "$cwd" \
      --tmpfs /tmp \
      ${pkgs.neovim-unwrapped}/bin/nvim "''${nvim_args[@]}"
  '';
  nvimBwrapPackage = pkgs.symlinkJoin {
    name = "neovim-unwrapped-bwrap";
    paths = [pkgs.neovim-unwrapped];
    nativeBuildInputs = [pkgs.makeWrapper];
    meta =
      pkgs.neovim-unwrapped.meta
      // {
        mainProgram = "nvim";
      };
    postBuild = ''
      rm "$out/bin/nvim"
      makeWrapper ${pkgs.bash}/bin/bash "$out/bin/nvim" \
        --add-flags ${lib.escapeShellArg nvimBwrapLauncher}
    '';
  };
in {
  programs.neovim = {
    enable = true;
    package = nvimBwrapPackage;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    withRuby = false;
    withPython3 = false;

    # these packages will only be available to neovim
    # see ./lua/myconfig/formatters.lua and ./lua/myconfig/lspservers.lua
    # for making them known to neovim
    extraPackages = with pkgs; [
      tree-sitter
      gcc # treesitter needs gcc

      # Lua LSP
      lua5_1
      lua-language-server # LSP
      luarocks
      stylua # formatter

      # Nix
      alejandra #formatter
      nixd # LSP

      # Python
      ruff

      prettier
    ];

    # the only plugin that I need is lazy, because lazy will load the rest of the plugins
    # that is made reproducable by committing the lazy-lock.json file
    plugins = [pkgs.vimPlugins.lazy-nvim];

    # define store paths before requiring the repo config
    initLua = ''
      _G.myconfig_paths = {
        lua_ls = "${pkgs.lua-language-server}/bin/lua-language-server",
        nixd = "${pkgs.nixd}/bin/nixd",
        codex = "${pkgs.llm-agents.codex}/bin/codex",
      }
      require("myconfig")
    '';
  };

  # symlink my git repo into the neovim conifg
  home.file.".config/nvim/lazy-lock.json".source = mkGitSymlink "/home/neovim/lazy.lock";
  home.file.".config/nvim/lua".source = mkGitSymlink "/home/neovim/lua";
  home.file.".local/bin/v".source = "${config.programs.neovim.finalPackage}/bin/nvim";
}
