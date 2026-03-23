-- some helpers
local all_modes = { "n", "i", "v", "s", "c" }

local function reload_listed_buffers(opts)
  opts = opts or {}

  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_view = vim.fn.winsaveview()
  local reloaded = 0
  local skipped_modified = 0

  for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if info.changed == 1 then
      skipped_modified = skipped_modified + 1
    elseif info.name ~= "" then
      local winid = vim.fn.bufwinid(info.bufnr)

      if winid ~= -1 then
        vim.api.nvim_win_call(winid, function()
          vim.cmd("silent! keepalt keepjumps edit!")
        end)
        reloaded = reloaded + 1
      else
        vim.cmd(("silent! checktime %d"):format(info.bufnr))
        reloaded = reloaded + 1
      end
    end
  end

  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end

  if vim.api.nvim_buf_is_valid(current_buf) and vim.api.nvim_get_current_buf() == current_buf then
    vim.fn.winrestview(current_view)
  end

  if opts.restart_lsp then
    local ok = pcall(vim.cmd, "LspRestart")
    if not ok then
      vim.notify("LspRestart not available", vim.log.levels.WARN)
    end
  end

  local message = ("Reloaded %d buffer(s) from disk"):format(reloaded)
  if skipped_modified > 0 then
    message = ("%s, skipped %d modified"):format(message, skipped_modified)
  end
  vim.notify(message, vim.log.levels.INFO)
end

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select entire buffer" })

-- Clipboard and registers
-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- keep last yanked when pasting in visual mode
vim.keymap.set("v", "p", '"_dP')

-- yank and paste from system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+y', true, false, true), "n", false)
  vim.notify("Yanked to clipboard!")
end, { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>yy", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+yy', true, false, true), "n", false)
  vim.notify("Yanked line to clipboard!")
end, { noremap = true, silent = true, desc = "Yank line to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+p', true, false, true), "n", false)
  vim.notify("Paste from clipboard!")
end, { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Reload buffers
vim.keymap.set("n", "<leader>r", function()
  reload_listed_buffers()
end, { desc = "Reload all buffers from disk" })

-- Save all files
vim.keymap.set(all_modes, "<C-s>", function()
  vim.cmd("wa")
  vim.notify("All buffers saved!", vim.log.levels.INFO)
end, { desc = "Save all buffers" })

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
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope neoclip<cr>", { desc = "Telescope help tags" })

-- Neotree
vim.keymap.set("n", "<C-e>", "<cmd>Neotree toggle reveal<cr>", { desc = "Toggle file explorer" })

-- Lsp

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
  vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)

  -- use telescope for these commands
  local ts = require("telescope.builtin")
  vim.keymap.set("n", "gs", ts.lsp_document_symbols, {})
  vim.keymap.set("n", "gw", ts.lsp_workspace_symbols, {})
  vim.keymap.set("n", "gr", ts.lsp_references, {})
  vim.keymap.set("n", "gd", ts.lsp_definitions, {})
  vim.keymap.set("n", "gi", ts.lsp_implementations, {})
  vim.keymap.set("n", "gt", ts.lsp_type_definitions, {})
end

require("lsp-zero").extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Formatting
vim.keymap.set("n", "<leader>F", function()
  local formatted = require("conform").format({ async = false })
  if formatted then
    vim.notify("Formatted!", vim.log.INFO)
  else
    vim.notify("Formatter not found", "error")
  end
end, { desc = "Format current buffer" })

-- Diagnostics
local ts = require("telescope.builtin")
vim.keymap.set("n", "<leader>qa", ts.diagnostics, { desc = "Open diagnostic quickfix list" })
vim.keymap.set("n", "<leader>q", function()
  ts.diagnostics({
    severity = vim.diagnostic.severity.ERROR,
    bufnr = nil, -- `nil` means search *all* buffers (workspace)
  })
end, { desc = "Telescope: workspace errors only" })
vim.keymap.set("n", "g]", function()
  vim.diagnostic.goto_next({
    severity = vim.diagnostic.severity.ERROR,
    wrap = false,
  })
end, { desc = "Next error" })

vim.keymap.set("n", "g[", function()
  vim.diagnostic.goto_prev({
    severity = vim.diagnostic.severity.ERROR,
    wrap = false,
  })
end, { desc = "Previous error" })

-- Notify
-- Additionally to the normal escape behavior, clear the search messages (noh) and clear the notifications
vim.keymap.set("", "<Esc>", "<ESC>:noh<CR>:lua require('notify').dismiss()<CR>", { silent = true })

-- Copilot
vim.keymap.set("n", "<leader>C", function()
  local copilot = require("copilot.suggestion")
  local auto_trigger = not (vim.g.copilot_auto_trigger or false)

  -- set global
  vim.g.copilot_auto_trigger = auto_trigger
  copilot.auto_trigger = auto_trigger

  -- sync with current buffer
  vim.b.copilot_suggestion_auto_trigger = auto_trigger

  if auto_trigger then
    vim.notify("Copilot auto-suggestion ON (global)", vim.log.levels.INFO)
  else
    vim.notify("Copilot auto-suggestion OFF (global)", vim.log.levels.INFO)
  end
end, { desc = "Toggle Copilot auto-suggestion globally" })

vim.keymap.set("n", "<leader>co", function()
  vim.cmd("CopilotChatOpen")
end, { desc = "CopilotChatOpen" })

-- ensure new buffers follow the global setting
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.g.copilot_auto_trigger ~= nil then
      vim.b.copilot_suggestion_auto_trigger = vim.g.copilot_auto_trigger
    end
  end,
})

-- Refactoring
require("telescope").load_extension("refactoring")
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  require("telescope").extensions.refactoring.refactors()
end)

-- Themery
vim.keymap.set("n", "<leader>t", "<cmd>Themery<CR>", opts)
