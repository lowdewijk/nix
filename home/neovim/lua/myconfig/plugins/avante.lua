return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "Avante" },
      opts = {
        file_types = { "markdown", "Avante" },
      },
    },
  },
  opts = {
    provider = "codex",
    behaviour = {
      auto_approve_tool_permissions = false,
      acp_follow_agent_locations = true,
    },
    acp_providers = {
      codex = {
        command = "codex-acp",
        env = {
          NODE_NO_WARNINGS = "1",
          CODEX_API_KEY = os.getenv("CODEX_API_KEY"),
          OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
        },
      },
    },
  },
}
