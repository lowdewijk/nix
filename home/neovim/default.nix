{ pkgs, globals, config, ... }:

let 
  mkGitSymlink = git_path: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${git_path}");
in {
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

  # symlink my git repo into the neovim conifg
  home.file.".config/nvim/lazy-lock.json".source = mkGitSymlink "/home/neovim/lazy.lock";
  home.file.".config/nvim/lua".source = mkGitSymlink "/home/neovim/lua";
}
