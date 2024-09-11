{ lib, pkgs, ...}:
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true; 
    vimdiffAlias = true;
    defaultEditor = true;

    catppuccin.enable = true;

    extraLuaConfig = lib.fileContents ./init.lua;
    plugins = with pkgs.vimPlugins; [
       vim-sleuth
       comment-nvim
       gitsigns-nvim
       which-key-nvim
       telescope-nvim
       telescope-ui-select-nvim
       telescope-fzf-native-nvim
       nvim-web-devicons
       mason-nvim
       mason-lspconfig-nvim
       mason-tool-installer-nvim
       fidget-nvim
       neodev-nvim
       conform-nvim
       nvim-cmp
       cmp-nvim-lsp
       cmp-path
       luasnip
       catppuccin-nvim
       todo-comments-nvim
       nvim-treesitter
       tmux-nvim
    ];
  };
}
