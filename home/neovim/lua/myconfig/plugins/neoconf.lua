return {
  "folke/neoconf.nvim",
  config = function()
    require("neoconf").setup({
      -- override any of the default settings here
      vim.notify("neo conf loaded"),
    })
  end,
}
