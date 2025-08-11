-- tests/test_story_001_preview.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("STORY-001: 即時預覽功能", function()
  --[[
  As a Neovim 用戶
  I want to 在瀏覽器中即時預覽 D2 圖表
  So that 我可以立即看到圖表的視覺效果

  Acceptance Criteria:
  1. AC-01: 啟動預覽伺服器
     - 使用 d2 --watch 命令啟動監控模式
     - 支援自動選擇可用埠號
     - 自動開啟預設瀏覽器
  2. AC-02: 預覽控制指令
     - 提供 :D2Preview 啟動預覽
     - 提供 :D2PreviewStop 停止預覽
     - 顯示預覽 URL
  3. AC-03: 檔案變更自動重載
     - D2 CLI 的 watch 模式已內建熱重載功能
     - 儲存檔案時自動觸發重新編譯
  ]]

  -- AC-01: 啟動預覽伺服器
  describe("AC-01: 啟動預覽伺服器", function()
    -- Cycle 1/3: 檢查 D2 CLI 存在性
    it("應該能檢測到 D2 CLI 是否已安裝", function()
      -- Given: 我是一個 Neovim 用戶準備使用 D2 plugin
      -- When: plugin 初始化時檢查 D2 CLI
      -- Then: 應該能夠檢測到 D2 CLI 的存在

      local cli = require("d2.cli")
      local d2_exists = cli.check_binary()
      
      assert.is_not_nil(d2_exists, "應該返回 D2 CLI 的檢查結果")
      assert.is_true(type(d2_exists) == "boolean", "應該返回布林值")
    end)
    
    -- Cycle 2/3: 真實檢查 D2 binary
    it("當 D2 未安裝時應該返回 false 並提供錯誤訊息", function()
      -- Given: D2 CLI 未安裝在系統上
      -- When: 檢查 D2 是否存在
      -- Then: 應該返回 false 和相應的錯誤訊息
      
      local cli = require("d2.cli")
      
      -- Mock vim.fn.executable 返回 0（表示不存在）
      local original_executable = vim.fn.executable
      vim.fn.executable = function(cmd)
        if cmd == "d2" then
          return 0
        end
        return original_executable(cmd)
      end
      
      local exists, error_msg = cli.check_binary()
      
      -- 恢復原始函數
      vim.fn.executable = original_executable
      
      assert.is_false(exists, "當 D2 未安裝時應該返回 false")
      assert.is_not_nil(error_msg, "應該提供錯誤訊息")
      assert.is_truthy(error_msg:match("D2 CLI not found"), "錯誤訊息應該說明 D2 未找到")
    end)
    
    -- Cycle 3/3: 啟動 watch 模式
    it("應該能啟動 D2 watch 模式進行預覽", function()
      -- Given: D2 CLI 已安裝且有一個 D2 檔案
      -- When: 呼叫啟動預覽功能
      -- Then: 應該啟動 d2 --watch 進程
      
      local cli = require("d2.cli")
      
      -- Mock vim.fn.jobstart 來捕獲命令
      local captured_cmd = nil
      local original_jobstart = vim.fn.jobstart
      vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1234  -- 返回假的 job ID
      end
      
      -- 執行預覽啟動
      local job_id = cli.start_preview("test.d2", {
        port = 0,
        browser = "none"
      })
      
      -- 恢復原始函數
      vim.fn.jobstart = original_jobstart
      
      assert.is_not_nil(job_id, "應該返回 job ID")
      assert.equals(1234, job_id, "應該返回正確的 job ID")
      assert.is_not_nil(captured_cmd, "應該執行命令")
      assert.is_truthy(table.concat(captured_cmd, " "):match("d2.*--watch"), "應該使用 d2 --watch 命令")
    end)
  end)
end)