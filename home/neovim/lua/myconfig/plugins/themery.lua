return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = {
        {
          name = "Catppuccin Mocha",
          colorscheme = "catppuccin-mocha",
          before = [[
            require("catppuccin").setup({
              flavour = "mocha",
              transparent_background = true,
            })
          ]],
        },
        {
          name = "Catppuccin Latte",
          colorscheme = "catppuccin-latte",
          before = [[
            require("catppuccin").setup({
              flavour = "latte",
              transparent_background = false,
            })
          ]],
        },
      },
      livePreview = true,
    })
  end,
}
