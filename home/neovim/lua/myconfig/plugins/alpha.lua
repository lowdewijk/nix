return {
  'goolord/alpha-nvim',
  dependencies = {
    'echasnovski/mini.icons',
    'nvim-lua/plenary.nvim'
  },
  config = function ()
    local theme = require'alpha.themes.theta'
    local dashboard = require("alpha.themes.dashboard")

    theme.buttons = {
      type = "group",
      val = {
          { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
          { type = "padding", val = 1 },
          dashboard.button("e", "  New file", "<cmd>ene<CR>"),
          dashboard.button("SPC f f", "󰈞  Find file"),
          dashboard.button("SPC f g", "󰊄  Live grep"),
          dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
      },
      position = "center",
    }
    theme.header.val = [[
                                              
       ████ ██████           █████      ██
      ███████████             █████ 
      █████████ ███████████████████ ███   ███████████
     █████████  ███    █████████████ █████ ██████████████
    █████████ ██████████ █████████ █████ █████ ████ █████
  ███████████ ███    ███ █████████ █████ █████ ████ █████
 ██████  █████████████████████ ████ █████ █████ ████ ██████

      ]]
    theme.config.layout[6] = theme.buttons
    require'alpha'.setup(theme.config)
  end
};
