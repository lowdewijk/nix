vim.opt.termguicolors = true

-- Nerd font
vim.g.have_nerd_font = true

-- Enable mouse mode in 'a'll modes
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Highlight cursor line
vim.opt.cursorline = true

-- Case-insensitive searching UNLESS one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview all substitutions in a temp split pane
vim.opt.inccommand = "split"

-- Smart tabs and prefer two spaces
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Relative line numbers
vim.opt.relativenumber = false

-- They tell me about tabs vs spaces and help me
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

-- Make linewrap respect indents
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Decrease update time for snappiness
vim.o.updatetime = 250

-- Wait timeout for action after mapped key sequence
vim.o.timeoutlen = 1000
