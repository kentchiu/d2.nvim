-- lua/d2/preview.lua
-- D2 預覽功能模組

local M = {}
local cli = require("d2.cli")

-- 預覽狀態
local state = {
  running = false,
  job_id = nil,
  port = nil,
  url = nil
}

-- 啟動預覽
M.start = function(file_path)
  -- 如果已在執行，先停止
  if state.running then
    vim.notify("Preview already running, stopping first...", vim.log.levels.INFO)
    M.stop()
  end
  
  file_path = file_path or vim.fn.expand("%:p")
  
  -- 檢查檔案是否為 .d2
  if not file_path:match("%.d2$") then
    vim.notify("Current file is not a .d2 file", vim.log.levels.ERROR)
    return false
  end
  
  -- 檢查檔案是否存在
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("File does not exist: " .. file_path, vim.log.levels.ERROR)
    return false
  end
  
  -- 檢查 D2 CLI
  local exists, err = cli.check_binary()
  if not exists then
    vim.notify(err or "D2 CLI not found", vim.log.levels.ERROR)
    return false
  end
  
  -- 啟動預覽伺服器
  local job_id = cli.start_preview(file_path, {
    port = 0,
    browser = "" -- 讓 D2 使用預設瀏覽器
  })
  
  if job_id and job_id > 0 then
    state.running = true
    state.job_id = job_id
    vim.notify("D2 preview starting... Check your browser", vim.log.levels.INFO)
    return true
  else
    vim.notify("Failed to start D2 preview", vim.log.levels.ERROR)
    return false
  end
end

-- 停止預覽
M.stop = function()
  if state.job_id then
    vim.fn.jobstop(state.job_id)
    state.running = false
    state.job_id = nil
    state.port = nil
    state.url = nil
    return true
  end
  return false
end

-- 獲取狀態
M.status = function()
  return {
    running = state.running,
    job_id = state.job_id,
    port = state.port,
    url = state.url
  }
end

return M