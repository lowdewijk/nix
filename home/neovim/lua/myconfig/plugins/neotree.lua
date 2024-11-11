return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      -- do not keep neotree around if there are no other buffers open
      close_if_last_window = true,
      window = {
        position = "float",
      },
    })
  end,
}
