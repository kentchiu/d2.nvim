-- lua/d2/init.lua
-- D2.nvim 主模組

local M = {}

-- 追蹤是否已設置
M._setup_done = false

-- 註冊預覽命令
local function register_preview_commands()
  vim.api.nvim_create_user_command("D2Preview", function(args)
    local preview = require("d2.preview")
    local success = preview.start()
    if success then
      vim.notify("D2 preview started", vim.log.levels.INFO)
    end
  end, {
    desc = "Start D2 preview server",
    nargs = 0
  })
  
  vim.api.nvim_create_user_command("D2PreviewStop", function(args)
    local preview = require("d2.preview")
    local success = preview.stop()
    if success then
      vim.notify("D2 preview stopped", vim.log.levels.INFO)
    else
      vim.notify("No preview running", vim.log.levels.WARN)
    end
  end, {
    desc = "Stop D2 preview server",
    nargs = 0
  })
end

-- 生成輸出檔名 (與 D2 檔案同名)
local function generate_output_filename(current_file, format)
  local dir = vim.fn.fnamemodify(current_file, ":h")
  local base = vim.fn.fnamemodify(current_file, ":t:r")
  return string.format("%s/%s.%s", dir, base, format)
end

-- 註冊配置命令
local function register_config_commands()
  local config = require("d2.config")
  
  -- D2SetLayout 命令
  vim.api.nvim_create_user_command("D2SetLayout", function(args)
    config.set_layout(args.args)
    vim.notify("D2 layout set to: " .. args.args, vim.log.levels.INFO)
  end, {
    desc = "Set D2 layout engine",
    nargs = 1,
    complete = function()
      return {"dagre", "elk", "tala"}
    end
  })
  
  -- D2ToggleSketch 命令
  vim.api.nvim_create_user_command("D2ToggleSketch", function()
    config.toggle_sketch()
    local status = config.get().sketch and "enabled" or "disabled"
    vim.notify("D2 sketch mode " .. status, vim.log.levels.INFO)
  end, {
    desc = "Toggle D2 sketch mode",
    nargs = 0
  })
  
  -- D2SetTheme 命令
  vim.api.nvim_create_user_command("D2SetTheme", function(args)
    local theme_id = tonumber(args.args)
    if theme_id and config.set_theme(theme_id) then
      vim.notify("D2 theme set to: " .. theme_id, vim.log.levels.INFO)
    else
      vim.notify("Invalid theme ID (must be a number between 0-300)", vim.log.levels.ERROR)
    end
  end, {
    desc = "Set D2 theme",
    nargs = 1
  })
  
  -- D2ShowConfig 命令
  vim.api.nvim_create_user_command("D2ShowConfig", function()
    local info = config.show()
    vim.notify(info, vim.log.levels.INFO)
  end, {
    desc = "Show current D2 configuration",
    nargs = 0
  })
end

-- 解析導出參數
local function parse_export_args(args_str)
  local format = "svg"
  local bundle = false
  
  if args_str and args_str ~= "" then
    if args_str:match("bundle") then
      bundle = true
    end
    if args_str:match("png") then
      format = "png"
    end
  end
  
  return format, bundle
end

-- 建構導出命令
local function build_export_command(current_file, output_file, bundle)
  local cmd = {"d2", current_file, output_file}
  
  if bundle then
    table.insert(cmd, "--bundle")
  end
  
  -- 加入配置參數
  local config = require("d2.config")
  local config_args = config.get_cli_args()
  for _, arg in ipairs(config_args) do
    table.insert(cmd, arg)
  end
  
  return cmd
end

-- 執行導出
local function execute_export(cmd, output_file)
  vim.fn.jobstart(cmd, {
    on_exit = function(job_id, exit_code, event)
      if exit_code == 0 then
        vim.notify("✅ D2 export completed: " .. output_file, vim.log.levels.INFO)
      else
        vim.notify("❌ D2 export failed", vim.log.levels.ERROR)
      end
    end
  })
end

-- 處理檔案覆蓋確認
local function handle_file_overwrite(output_file, export_callback)
  if vim.fn.filereadable(output_file) == 1 then
    vim.ui.select(
      {"Yes", "No"},
      {
        prompt = string.format("File '%s' already exists. Overwrite?", vim.fn.fnamemodify(output_file, ":t")),
      },
      function(choice)
        if choice == "Yes" then
          export_callback()
        else
          vim.notify("Export cancelled", vim.log.levels.INFO)
        end
      end
    )
  else
    export_callback()
  end
end

-- 註冊導出命令
local function register_export_command()
  vim.api.nvim_create_user_command("D2Export", function(args)
    local current_file = vim.api.nvim_buf_get_name(0)
    local format, bundle = parse_export_args(args.args)
    local output_file = generate_output_filename(current_file, format)
    
    local function do_export()
      local cmd = build_export_command(current_file, output_file, bundle)
      execute_export(cmd, output_file)
    end
    
    handle_file_overwrite(output_file, do_export)
  end, {
    desc = "Export D2 diagram to SVG/PNG",
    nargs = "?",
    complete = function()
      return {"svg", "png", "bundle"}
    end
  })
end

-- 設置 plugin
M.setup = function(opts)
  -- 避免重複設置
  if M._setup_done then
    return
  end
  
  opts = opts or {}
  
  -- 設置配置
  local config = require("d2.config")
  config.setup(opts)
  
  -- 註冊所有命令
  register_preview_commands()
  register_export_command()
  register_config_commands()
  
  -- 設置 treesitter
  local treesitter = require("d2.treesitter")
  treesitter.setup()
  
  M._setup_done = true
end

return M