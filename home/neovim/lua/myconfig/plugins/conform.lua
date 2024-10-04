-- conform is a code formatter adapter
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandro" },
    },
  },
}
