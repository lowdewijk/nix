local M = {}

local function starts_with(text, prefix)
  return text:sub(1, #prefix) == prefix
end

local function top_level_dir(home_dir, path)
  local rel_path = path:sub(#home_dir + 2)
  local slash_index = rel_path:find("/", 1, true)

  if slash_index == nil then
    return rel_path
  end

  return rel_path:sub(1, slash_index - 1)
end

function M.is_safe_dir(home_dir, path)
  if path == home_dir then
    return false
  end

  if starts_with(path, home_dir .. "/") then
    return not starts_with(top_level_dir(home_dir, path), ".")
  end

  return false
end

function M.decide(opts)
  local clean = false
  local bind_dirs = {}
  local seen = {}
  local has_explicit_targets = #opts.explicit_target_dirs > 0

  if has_explicit_targets then
    for _, target_dir in ipairs(opts.explicit_target_dirs) do
      if not M.is_safe_dir(opts.home_dir, target_dir) then
        clean = true
      end

      if target_dir ~= opts.workspace and not starts_with(target_dir, opts.workspace .. "/") then
        if not seen[target_dir] then
          seen[target_dir] = true
          table.insert(bind_dirs, target_dir)
        end
      end
    end
  elseif not M.is_safe_dir(opts.home_dir, opts.cwd) then
    clean = true
  end

  return {
    clean = clean,
    bind_dirs = bind_dirs,
  }
end

return M
