{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = git_path: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${git_path}");
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    # these packages will only be available to neovim
    # see ./lua/myconfig/formatters.lua and ./lua/myconfig/lspservers.lua
    # for making them known to neovim
    extraPackages = with pkgs; [
      # Lua LSP
      lua5_1
      lua-language-server # LSP
      luarocks
      stylua # formatter

      # Nix
      alejandra #formatter
      nixd # LSP

      # Python
      nodejs # required by pyright
      pyright
    ];

    # the only plugin that I need is lazy, because lazy will load the rest of the plugins
    # that is made reproducable by committing the lazy-lock.json file
    plugins = [pkgs.vimPlugins.lazy-nvim];

    # see ./lua/myconfig/init.lua
    extraLuaConfig = ''require("myconfig")'';
  };

  # symlink my git repo into the neovim conifg
  home.file.".config/nvim/lazy-lock.json".source = mkGitSymlink "/home/neovim/lazy.lock";
  home.file.".config/nvim/lua".source = mkGitSymlink "/home/neovim/lua";
}
