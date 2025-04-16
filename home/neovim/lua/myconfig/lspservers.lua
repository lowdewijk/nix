require("lspconfig")["lua_ls"].setup({
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- pull in all of 'runtimepath'.
        library = vim.api.nvim_get_runtime_file("", true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

require("lspconfig")["nixd"].setup({})

require("lspconfig")["pyright"].setup({
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
      },
    },
  },
})

require("lspconfig")["rust_analyzer"].setup({
  settings = {
    ["rust-analyzer"] = {
      -- by default enable all features in LSP
      cargo = {
        buildScripts = {
          enable = true,
        },
        features = "all",
      },
      -- clippy
      check = {
        command = "clippy",
      },
    },
  },
})
