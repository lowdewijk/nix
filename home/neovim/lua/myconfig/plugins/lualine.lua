return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- display macro recording
    { "yavorski/lualine-macro-recording.nvim" },
  },
  opts = {
    sections = {
      -- add to section of your choice
      lualine_c = { "filename", "macro_recording", "%S" },
    },
  },
}
