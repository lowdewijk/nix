return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      -- I want to enable copilot explicitly,  so it it not in my way.
      auto_trigger = false,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}
