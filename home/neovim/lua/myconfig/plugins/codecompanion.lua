return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
  },
  keys = {
    {
      "<leader>cf",
      function()
        local chat = require("codecompanion").buf_get_chat(0)
        if not chat or not chat.ui then
          return
        end

        chat.ui.cursor.has_moved = false
        chat.ui.cursor.pos = nil
        chat.ui:follow()

        vim.notify("CodeCompanion auto-scroll re-enabled")
      end,
      desc = "Re-enable CodeCompanion auto-scroll",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = {
              auth_method = "chatgpt",
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        adapter = "codex",
      },
    },
  },
}
