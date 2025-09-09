-- lua/d2/config.lua

local M = {}

-- 常數定義
local THEME_MIN = 0
local THEME_MAX = 300
local DEFAULT_PAD = 100
local DEFAULT_PORT = 0

-- 預設配置
M.defaults = {
  layout = "elk",
  sketch = true,
  theme = THEME_MIN,
  pad = DEFAULT_PAD,
  dark_theme = nil,
  force_appendix = false,
  animate_interval = nil,
}

-- 使用者配置
M.options = {}

-- 確保配置已初始化
local function ensure_options_initialized()
  if vim.tbl_isempty(M.options) then
    M.options = vim.tbl_deep_extend("force", {}, M.defaults)
  end
end

-- Setup 函數
M.setup = function(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

-- 輔助函數：添加 CLI 參數
local function add_cli_arg(args, flag, value)
  if value ~= nil then
    table.insert(args, flag)
    if type(value) == "boolean" then
      -- 布林值參數不需要值
      if not value then
        -- 如果是 false，不加入參數
        table.remove(args, #args)
      end
    else
      table.insert(args, tostring(value))
    end
  end
end

-- 取得 CLI 參數
M.get_cli_args = function()
  local args = {}

  -- 確保 options 已初始化
  ensure_options_initialized()

  -- 加入所有配置參數
  add_cli_arg(args, "--layout", M.options.layout)
  add_cli_arg(args, "--sketch", M.options.sketch)
  add_cli_arg(args, "--theme", M.options.theme)
  add_cli_arg(args, "--pad", M.options.pad)
  add_cli_arg(args, "--dark-theme", M.options.dark_theme)
  add_cli_arg(args, "--force-appendix", M.options.force_appendix)
  add_cli_arg(args, "--animate-interval", M.options.animate_interval)

  return args
end

-- 切換 sketch 模式
M.toggle_sketch = function()
  -- 確保 options 已初始化
  ensure_options_initialized()

  M.options.sketch = not M.options.sketch
end

-- 設定 theme
M.set_theme = function(theme_id)
  -- 確保 options 已初始化
  ensure_options_initialized()

  -- 驗證 theme ID 範圍
  if type(theme_id) == "number" and theme_id >= THEME_MIN and theme_id <= THEME_MAX then
    M.options.theme = theme_id
    return true
  end
  return false
end

-- 設定 layout
M.set_layout = function(layout)
  -- 確保 options 已初始化
  ensure_options_initialized()

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

