return {
  -- Treat our module folder as a “plugin” so lazy puts it on runtimepath
  name = "autoimport-local",
  dir = vim.fn.stdpath("config") .. "/lua/autoimport",
  ft = { "python" }, -- load only for Python buffers
  config = function()
    require("autoimport").setup({
      key = "<leader>a", -- your keybind
      select = true, -- show picker if multiple candidates
      organize_after = false, -- run pyright.organizeimports after import
    })
  end,
}
