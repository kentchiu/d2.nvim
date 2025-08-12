-- lua/d2/cli.lua
-- D2 CLI 包裝模組

local M = {}

-- 檢查 D2 CLI 是否可用
-- Cycle 2: 真實實作 - 使用 vim.fn.executable
M.check_binary = function()
  -- 使用 Neovim 內建函數檢查 d2 是否在 PATH 中
  local d2_exists = vim.fn.executable("d2") == 1
  
  if not d2_exists then
    return false, "D2 CLI not found. Please install D2 from https://d2lang.com"
  end
  
  return true, nil
end

-- 啟動 D2 預覽伺服器
-- Cycle 3: 實作 watch 模式
M.start_preview = function(file_path, opts)
  opts = opts or {}
  local config = require("d2.config")
  
  -- 建構 d2 命令
  local cmd = {
    "d2",
    "--watch",
    "--port", tostring(opts.port or 0),
    file_path
  }
  
  -- 只在明確設定時加入 browser 參數
  if opts.browser and opts.browser ~= "" then
    table.insert(cmd, "--browser")
    table.insert(cmd, opts.browser)
  end
  
  -- 加入配置參數
  local config_args = config.get_cli_args()
  for _, arg in ipairs(config_args) do
    table.insert(cmd, arg)
  end
  
  -- 使用 jobstart 啟動非同步進程
  local job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      -- 處理輸出
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            -- 顯示 D2 的輸出（如 URL）
            vim.schedule(function()
              vim.notify("D2: " .. line, vim.log.levels.INFO)
            end)
          end
        end
      end
    end,
    on_stderr = function(_, data, _)
      -- 處理錯誤輸出
      if data then
        for _, line in ipairs(data) do
          if line ~= "" and not line:match("^go:") then
            vim.schedule(function()
              -- 檢查是否為 URL 訊息
              if line:match("http://") or line:match("https://") then
                vim.notify("D2 Preview: " .. line, vim.log.levels.INFO)
              else
                -- 只顯示非空且有意義的錯誤
                if not line:match("^%s*$") then
                  vim.notify("D2: " .. line, vim.log.levels.WARN)
                end
              end
            end)
          end
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code ~= 0 then
          vim.notify("D2 preview stopped with exit code: " .. exit_code, vim.log.levels.ERROR)
        else
          vim.notify("D2 preview stopped", vim.log.levels.INFO)
        end
      end)
    end
  })
  
  return job_id
end

return M