-- tests/test_story_001_commands.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("STORY-001: 預覽控制指令", function()
  -- AC-02: 預覽控制指令
  describe("AC-02: 預覽控制指令", function()
    -- Cycle 1/3: 建立 :D2Preview 指令
    it("應該註冊 :D2Preview 命令", function()
      -- Given: D2 plugin 已載入
      -- When: 檢查可用命令
      -- Then: :D2Preview 應該存在
      
      -- 載入 plugin
      require("d2")
      
      -- 檢查命令是否存在
      local cmd_exists = vim.fn.exists(":D2Preview") == 2
      
      assert.is_true(cmd_exists, ":D2Preview 命令應該被註冊")
    end)
    
    -- Cycle 2/3: 實現預覽啟動邏輯
    it("D2Preview 應該啟動預覽伺服器", function()
      -- Given: 有一個 D2 檔案開啟
      -- When: 執行 :D2Preview 命令
      -- Then: 應該啟動預覽進程
      
      local d2 = require("d2")
      local preview = require("d2.preview")
      
      -- Mock 當前檔案
      local original_expand = vim.fn.expand
      vim.fn.expand = function(str)
        if str == "%:p" then
          return "/tmp/test.d2"
        end
        return original_expand(str)
      end
      
      -- 執行命令
      preview.start()
      
      -- 恢復
      vim.fn.expand = original_expand
      
      -- 驗證預覽狀態
      local status = preview.status()
      assert.is_not_nil(status, "應該有預覽狀態")
      assert.is_true(status.running or false, "預覽應該在執行中")
    end)
  end)
end)