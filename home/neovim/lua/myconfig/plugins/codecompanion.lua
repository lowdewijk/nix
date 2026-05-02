return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  cmd = {
    "CodeCompanionCLI",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    interactions = {
      cli = {
        agent = "codex",
        agents = {
          codex = {
            cmd = "codex",
            args = {
              "--sandbox",
              "workspace-write",
              "--ask-for-approval",
              "on-request",
            },
            description = "OpenAI Codex CLI",
            provider = "terminal",
          },
        },
      },
    },
  },
}
