return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = {
        {
          name = "Catppuccin Mocha",
          colorscheme = "catppuccin-mocha",
        },
        {
          name = "Catppuccin Latte",
          colorscheme = "catppuccin-latte",
        },
      },
      livePreview = true,
    })
  end,
}
