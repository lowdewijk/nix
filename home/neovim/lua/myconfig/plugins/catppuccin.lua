return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    local function setup(flavour)
      require("catppuccin").setup({
        flavour = flavour,
        transparent_background = flavour == "mocha",
        highlight_overrides = {
          all = function(colors)
            return {
              LineNrAbove = { fg = colors.subtext1 },
              LineNrBelow = { fg = colors.subtext1 },
              CursorLineNr = { fg = colors.yellow, bold = true },
              ["@parameter.call"] = { fg = colors.sapphire },
              ["@string.interpolation"] = { fg = colors.peach },
            }
          end,
        },
      })
    end

    vim.api.nvim_create_autocmd("ColorSchemePre", {
      group = vim.api.nvim_create_augroup("MyconfigCatppuccin", { clear = true }),
      pattern = "catppuccin*",
      callback = function(event)
        local flavour = event.match:match("^catppuccin%-(.+)$") or "mocha"
        setup(flavour)
      end,
    })

    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
