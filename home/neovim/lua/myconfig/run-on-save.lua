vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    local neoconf = require("neoconf")
    local run = neoconf.get("run-on-save")
    local commands = neoconf.get("commands")

    if run ~= nil and run.commands ~= nil and commands ~= nil then
      for _, command_name in ipairs(run.commands) do
        local command = commands[command_name]
        if command == nil or command.command == nil or command.args == nil then
          vim.notify(string.format("Cannot find command with name %s in commands list", command_name), "error")
        else
          local Job = require("plenary.job")
          Job:new({
            command = commands[command_name].command,
            args = commands[command_name].args,
            enable_recording = true,
            on_start = function()
              if run.start_msg ~= nil then
                vim.notify(run.start_msg)
              end
            end,
            on_stderr = function(error, data)
              if run.show_stderr then
                vim.notify(string.format("Error (%s): %s", error, data), "error")
              end
            end,
            on_exit = function(job, return_val)
              if return_val == 0 then
                if run.success_msg ~= nil then
                  vim.notify(run.success_msg)
                else
                  vim.notify(string.format("Run on save finished: %s", vim.inspect(job:result())))
                end
              else
                vim.notify(string.format("Error (%d): %s", return_val, vim.inspect(job:result())), "error")
              end
            end,
          }):start()
        end
      end
    end
  end,
})
