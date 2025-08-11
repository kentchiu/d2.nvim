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

-- 生成輸出檔名
local function generate_output_filename(current_file, format)
  local dir = vim.fn.fnamemodify(current_file, ":h")
  local base = vim.fn.fnamemodify(current_file, ":t:r")
  local timestamp = os.date("%Y%m%d_%H%M%S")
  return string.format("%s/%s_%s.%s", dir, base, timestamp, format)
end

-- 註冊導出命令
local function register_export_command()
  vim.api.nvim_create_user_command("D2Export", function(args)
    -- 獲取當前檔案
    local current_file = vim.api.nvim_buf_get_name(0)
    
    -- 解析參數
    local format = "svg"
    local bundle = false
    if args.args ~= "" then
      if args.args:match("bundle") then
        bundle = true
      end
      if args.args:match("png") then
        format = "png"
      end
    end
    
    -- 生成輸出檔名
    local output_file = generate_output_filename(current_file, format)
    
    -- 建構 d2 命令
    local cmd = {"d2", current_file, output_file}
    if bundle then
      table.insert(cmd, "--bundle")
    end
    
    vim.fn.jobstart(cmd, {
      on_exit = function(job_id, exit_code, event)
        if exit_code == 0 then
          vim.notify("✅ D2 export completed: " .. output_file, vim.log.levels.INFO)
        else
          vim.notify("❌ D2 export failed", vim.log.levels.ERROR)
        end
      end
    })
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
  
  -- 註冊所有命令
  register_preview_commands()
  register_export_command()
  
  M._setup_done = true
end

return M