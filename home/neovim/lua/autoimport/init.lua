local M = {}

-- core: import the symbol under cursor (with picker if multiple)
function M.import_symbol_under_cursor(opts)
	opts = opts or {}
	local timeout_ms = opts.timeout_ms or 1200
	local bufnr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	-- word boundaries
	local row, col = unpack(vim.api.nvim_win_get_cursor(win))
	local line = vim.api.nvim_get_current_line()
	local left = line:sub(1, col)
	local wb = left:find("[_%w]+$") or (col + 1)
	local we = (line:find("[^_%w]", wb) or (#line + 1)) - 1
	local cword = line:sub(wb, we)
	if cword == "" then
		vim.notify("No symbol under cursor", vim.log.levels.INFO)
		return
	end

	-- request completion at end-of-word (what Pyright expects)
	vim.api.nvim_win_set_cursor(win, { row, we })
	local pyright_id
	for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if c.name == "pyright" then
			pyright_id = c.id
			break
		end
	end
	local enc = (pyright_id and vim.lsp.get_client_by_id(pyright_id).offset_encoding) or "utf-16"
	local params = vim.lsp.util.make_position_params(win, enc)
	params.context = { triggerKind = 1 }

	local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/completion", params, timeout_ms)
	vim.api.nvim_win_set_cursor(win, { row, col })

	if not responses or vim.tbl_isempty(responses) then
		vim.notify("LSP: no completion responses", vim.log.levels.WARN)
		return
	end

	local candidates = {}
	for cid, resp in pairs(responses) do
		local res = resp and resp.result
		if res then
			local items = res.items or res
			for _, it in ipairs(items or {}) do
				if it and it.additionalTextEdits and #it.additionalTextEdits > 0 then
					table.insert(candidates, { item = it, client_id = cid })
				end
			end
		end
	end

	if #candidates == 0 then
		vim.notify("No auto-import candidate found for '" .. cword .. "'", vim.log.levels.INFO)
		return
	end

	local function apply(choice)
		if not choice then
			return
		end
		local client = vim.lsp.get_client_by_id(choice.client_id)
		local enc2 = (client and client.offset_encoding) or "utf-16"
		vim.lsp.util.apply_text_edits(choice.item.additionalTextEdits, bufnr, enc2)

		if opts.organize_after then
			vim.lsp.buf.execute_command({
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			})
		end

		vim.notify("Imported: " .. (choice.item.label or cword), vim.log.levels.INFO)
	end

	if #candidates == 1 or not opts.select then
		apply(candidates[1])
	else
		vim.ui.select(candidates, {
			prompt = "Select import for " .. cword .. ":",
			format_item = function(c)
				local mod = c.item.detail or (c.item.labelDetails and c.item.labelDetails.description) or ""
				return c.item.label .. (mod ~= "" and ("  [" .. mod .. "]") or "")
			end,
		}, apply)
	end
end

-- setup: keymap + command
function M.setup(opts)
	opts = opts or {}
	local key = opts.key or "<leader>a"
	local select = opts.select ~= false -- default: show selector if multiple
	local organize_after = opts.organize_after or false

	-- user command
	vim.api.nvim_create_user_command("AutoImport", function()
		M.import_symbol_under_cursor({ select = select, organize_after = organize_after })
	end, {})

	-- keymap
	vim.keymap.set("n", key, function()
		M.import_symbol_under_cursor({ select = select, organize_after = organize_after })
	end, { desc = "Auto-import symbol under cursor" })
end

return M
