{ pkgs, globals, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
    extraPackages = with pkgs; [
      # Lua LSP
      lua5_1
      lua-language-server
      luarocks
      stylua
      
      # Nix LSP
      alejandra
      nixd
    ];
    plugins = [ pkgs.vimPlugins.lazy-nvim ];
    extraLuaConfig = ''require("myconfig")'';
  };

  home.file.".config/nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/home/neovim/lazy.lock");

  home.file.".config/nvim/lua" = {
    source = config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/home/neovim/lua");
  };
}
