------------------------
-- GLOBAL KEYBINDINGS  --
-------------------------

-- some helpers
local all_modes = { "n", "i", "v", "s", "c" }

-- Reload neovim config keymap
-- Be aware that this isn't perfect and sometimes a restart is needed
vim.keymap.set("n", "<Leader>r", function()
  -- unload myconfig packages
  for name,_ in pairs(package.loaded) do
    if name:match('^myconfig') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload neovim config" })

vim.keymap.set(all_modes, "<C-s>", function()
  vim.cmd.write()
end, { desc = "Save current file" })

--Splitting panes keymaps
vim.keymap.set("n", "<Leader>%", function()
  vim.cmd.split()
end, { desc = "Split horizontally" })
vim.keymap.set("n", '<Leader>"', function()
  vim.cmd.vsplit()
end, { desc = "Split vertically" })

