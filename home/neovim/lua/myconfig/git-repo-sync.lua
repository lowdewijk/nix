vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    local neoconf = require("neoconf")
    local syncConfig = neoconf.get("git-repo-sync")
    if syncConfig ~= nil then
      local Job = require("plenary.job")
      Job:new({
        command = "git",
        args = { "repo-sync", "-l", syncConfig.source, "up", syncConfig.target },
        on_start = function()
          vim.notify(string.format("git-repo-sync in-progress (target = %s)", syncConfig.target))
        end,
        on_exit = function()
          vim.notify(string.format("git-repo-sync complete (target = %s)", syncConfig.target))
        end,
      }):start()
    end
  end,
})
