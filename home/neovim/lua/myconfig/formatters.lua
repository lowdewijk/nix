require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    typescriptreact = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    javascript = { "prettier" },
    python = { "ruff_format" },
  },
})
