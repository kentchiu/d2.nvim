-- lua/d2/init.lua
-- D2.nvim 主模組

local M = {}

-- 追蹤是否已設置
M._setup_done = false

-- 設置 plugin
M.setup = function(opts)
  -- 避免重複設置
  if M._setup_done then
    return
  end
  
  opts = opts or {}
  
  -- 註冊命令（全域，不限於 d2 檔案）
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
  
  M._setup_done = true
end

return M