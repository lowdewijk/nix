return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    "zbirenbaum/copilot.lua", -- Copilot backend
    "nvim-lua/plenary.nvim",
  },
  opts = {
    window = { layout = "float", width = 0.45, height = 0.6 },
    mappings = {
      close = {
        normal = "q", -- Keybinding for normal mode
        insert = "<C-c>",
      },
    },
  },
}
