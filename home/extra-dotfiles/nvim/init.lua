---------------------
-- GLOBAL OPTIONS  --
---------------------
    
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd font
vim.g.have_nerd_font = true

-- Enable mouse mode in 'a'll modes
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Highlight cursor line
vim.opt.cursorline = true

-- Case-insensitive searching UNLESS one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview all substitutions in a temp split pane
vim.opt.inccommand = 'split'

-- Misc
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true

-------------------------
-- GLOBAL KEYBINDINGS  --
-------------------------

-- some helpers 
local all_modes = { 'n', 'i', 'v', 's', 'c' } 

-- Reload neovim config keymap
-- Be aware that this isn't perfect and sometimes a restart is needed
vim.keymap.set('n', '<Leader>r', function() 
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload neovim config" })

vim.keymap.set(all_modes, '<C-s>', function() 
  vim.cmd.write()
end, { desc = "Save current file" })

--Splitting panes keymaps
vim.keymap.set('n', '<Leader>%', function()
  vim.cmd.split() 
end, { desc = 'Split horizontally' })
vim.keymap.set('n', '<Leader>"', function()
  vim.cmd.vsplit() 
end, { desc = 'Split vertically' })

--------------------
-- BOOTSTRAP LAZY --
--------------------

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override my plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable these pre-packaged neovim plugins that I never use
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

