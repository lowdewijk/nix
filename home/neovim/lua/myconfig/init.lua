-- Set <space> as the leader key
-- This needs to happen before lazy plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------
-- BOOTSTRAP LAZY --
--------------------

require("lazy").setup({
  spec = {
    { import = "myconfig/plugins" },
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

require("myconfig/opts")
require("myconfig/autocmds")
require("myconfig/keybinds")
require("myconfig/lspservers")
