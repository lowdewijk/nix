-- some helpers
local all_modes = { "n", "i", "v", "s", "c" }

-- Reload neovim config keymap
-- Be aware that this isn't perfect and sometimes a restart is needed
vim.keymap.set("n", "<Leader>r", function()
  -- unload myconfig packages
  for name, _ in pairs(package.loaded) do
    if name:match("^myconfig") then
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

-- Vim tmux navigator
vim.keymap.set(all_modes, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate to left pane" })
vim.keymap.set(all_modes, "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate to pane below" })
vim.keymap.set(all_modes, "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate to pane above" })
vim.keymap.set(all_modes, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate to right pane" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-s-e>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope neoclip<cr>", { desc = "Telescope help tags" })

-- Neotree
vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- Lsp

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(_, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
  vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

require("lsp-zero").extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Formatting
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = false })
end, { desc = "Format current buffer" })

-- Notify
vim.keymap.set("", "<Esc>", function()
  require("notify").dismiss()
end, { silent = true })
