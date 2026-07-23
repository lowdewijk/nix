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
  nvimBwrapRuntime = pkgs.symlinkJoin {
    name = "nvim-bwrap-runtime";
    paths = [
      (pkgs.writeTextDir "bin/nvim-bwrap.lua" (builtins.readFile ./bin/nvim-bwrap.lua))
      (pkgs.writeTextDir "lua/myconfig/nvim_bwrap.lua" (builtins.readFile ./lua/myconfig/nvim_bwrap.lua))
    ];
  };

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
  nvimLuaPath = "${nvimBwrapRuntime}/lua/?.lua;${nvimBwrapRuntime}/lua/?/init.lua";
  nvimBwrapLauncher = "${nvimBwrapRuntime}/bin/nvim-bwrap.lua";
  nvimBwrapTestRunner = pkgs.writeShellScriptBin "test-nvim-bwrap" ''
    set -euo pipefail

    export NVIM_BWRAP_LUA_PATH=${lib.escapeShellArg nvimLuaPath}
    exec ${pkgs.lua5_1}/bin/lua "${repoRoot}/home/neovim/tests/nvim_bwrap_spec.lua"
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
      makeWrapper ${pkgs.lua5_1}/bin/lua "$out/bin/nvim" \
        --set NVIM_BWRAP_BWRAP_BIN ${lib.escapeShellArg "${pkgs.bubblewrap}/bin/bwrap"} \
        --set NVIM_BWRAP_LUA_PATH ${lib.escapeShellArg nvimLuaPath} \
        --set NVIM_BWRAP_NEOVIM_BIN ${lib.escapeShellArg "${pkgs.neovim-unwrapped}/bin/nvim"} \
        --set NVIM_BWRAP_REPO_ROOT ${lib.escapeShellArg repoRoot} \
        --set NVIM_BWRAP_SANDBOXED_SSH_BIN ${lib.escapeShellArg "${sandboxedSshBin}/bin/ssh"} \
        --add-flags ${lib.escapeShellArg nvimBwrapLauncher}
    '';
  };
in {
  home.packages = [nvimBwrapTestRunner];

  programs.neovim = {
    enable = true;
    package = nvimBwrapPackage;
    defaultEditor = true;

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

      # TypeScript / JavaScript
      nodejs
      typescript
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
