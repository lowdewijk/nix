{ pkgs, ... }:

let
  edit-neovim = pkgs.writeScriptBin "edit-neovim" (builtins.readFile ./edit-neovim);
  nix-neovim = pkgs.writeScriptBin "nix-neovim" (builtins.readFile ./nix-neovim);
in {
  home.packages =  [
    edit-neovim
    nix-neovim
  ];

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

  home.file.".config/nvim/lazy-lock.json".source = ./lazy-lock.json;

  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
