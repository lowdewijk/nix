return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
    })
    vim.cmd("colorscheme catppuccin")
    local palette = require("catppuccin.palettes").get_palette("mocha")
    vim.api.nvim_set_hl(0, "@parameter.call", { fg = palette.sapphire })
    vim.api.nvim_set_hl(0, "@string.interpolation", { fg = palette.peach })
  end,
}
