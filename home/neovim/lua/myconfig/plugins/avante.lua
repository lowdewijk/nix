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
    provider = "openai",
    auto_suggestions_provider = "openai",
    behaviour = {
      auto_suggestions = true,
    },
    mappings = {
      suggestion = {
        accept = "<Tab>",
      },
    },
    providers = {
      openai = {
        model = "gpt-4o",
      },
    },
  },
}
