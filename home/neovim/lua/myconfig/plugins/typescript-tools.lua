return {
  "pmizio/typescript-tools.nvim",
  ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    -- Override upstream defaults that include parser-style names
    -- ("javascript.jsx", "typescript.tsx") instead of Neovim filetypes.
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
}
