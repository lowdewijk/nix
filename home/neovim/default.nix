{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    vimPlugins.LazyVim
  ];

  home.file."bla".text = "foobar";

  home.file.".config/nvim/init.lua".text = ''
    -- Add lazy to neovim's run time path
    vim.opt.rtp:append("${pkgs.vimPlugins.LazyVim}")
    require("myconfig")
  '';

  home.file.".config/nvim/lazy-lock.json".source = ./lazy-lock.json;

  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
