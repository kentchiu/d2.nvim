-- lua/d2/config.lua

local M = {}

-- 預設配置
M.defaults = {
  layout = "elk",
  sketch = true,
  theme = 0,
  pad = 100,
  dark_theme = nil,
  force_appendix = false,
  animate_interval = nil,
}

-- 使用者配置
M.options = {}

-- Setup 函數
M.setup = function(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

-- 取得 CLI 參數
M.get_cli_args = function()
  local args = {}

  -- 確保 options 已初始化
  if vim.tbl_isempty(M.options) then
    M.options = M.defaults
  end

  -- 加入 layout 參數
  if M.options.layout then
    table.insert(args, "--layout")
    table.insert(args, M.options.layout)
  end

  -- 加入 sketch 參數
  if M.options.sketch then
    table.insert(args, "--sketch")
  end

  -- 加入 theme 參數
  if M.options.theme then
    table.insert(args, "--theme")
    table.insert(args, tostring(M.options.theme))
  end

  -- 加入 pad 參數
  if M.options.pad then
    table.insert(args, "--pad")
    table.insert(args, tostring(M.options.pad))
  end

  -- 加入 dark-theme 參數
  if M.options.dark_theme then
    table.insert(args, "--dark-theme")
    table.insert(args, tostring(M.options.dark_theme))
  end

  -- 加入 force-appendix 參數
  if M.options.force_appendix then
    table.insert(args, "--force-appendix")
  end

  -- 加入 animate-interval 參數
  if M.options.animate_interval then
    table.insert(args, "--animate-interval")
    table.insert(args, tostring(M.options.animate_interval))
  end

  return args
end

-- 切換 sketch 模式
M.toggle_sketch = function()
  -- 確保 options 已初始化
  if vim.tbl_isempty(M.options) then
    M.options = vim.tbl_deep_extend("force", {}, M.defaults)
  end

  M.options.sketch = not M.options.sketch
end

-- 設定 theme
M.set_theme = function(theme_id)
  -- 確保 options 已初始化
  if vim.tbl_isempty(M.options) then
    M.options = vim.tbl_deep_extend("force", {}, M.defaults)
  end

  -- 驗證 theme ID 範圍
  if type(theme_id) == "number" and theme_id >= 0 and theme_id <= 300 then
    M.options.theme = theme_id
    return true
  end
  return false
end

-- 設定 layout
M.set_layout = function(layout)
  -- 確保 options 已初始化
  if vim.tbl_isempty(M.options) then
    M.options = vim.tbl_deep_extend("force", {}, M.defaults)
  end

  M.options.layout = layout
end

-- 取得當前配置
M.get = function()
  if vim.tbl_isempty(M.options) then
    return M.defaults
  end
  return M.options
end

-- 顯示配置
M.show = function()
  local config = M.get()
  local lines = { "D2.nvim Configuration:" }

  for key, value in pairs(config) do
    table.insert(lines, string.format("  %s: %s", key, vim.inspect(value)))
  end

  return table.concat(lines, "\n")
end

return M

