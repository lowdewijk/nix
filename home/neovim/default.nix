{ pkgs, ... }:

let
  edit-neovim = pkgs.writeScriptBin "edit-neovim" (builtins.readFile ./edit-neovim);
  nix-neovim = pkgs.writeScriptBin "nix-neovim" (builtins.readFile ./nix-neovim);
in {
  home.packages = with pkgs; [
    neovim
    vimPlugins.lazy-nvim
    edit-neovim
    nix-neovim
  ];

  home.file.".config/nvim/init.lua".text = ''
    -- Add lazy to neovim's run time path
    vim.opt.rtp:append("${pkgs.vimPlugins.lazy-nvim}")
    require("myconfig")
  '';

  home.file.".config/nvim/lazy-lock.json".source = ./lazy-lock.json;

  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
