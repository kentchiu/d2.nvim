-- tests/test_story_004_health.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("STORY-004: 健康檢查功能", function()
  --[[
  As a Neovim 用戶
  I want to 診斷 D2.nvim 的安裝狀態
  So that 我可以快速排除問題

  Acceptance Criteria:
  1. AC-01: 實作 :checkhealth 支援
     - 檢查 D2 CLI 是否安裝及版本
     - 檢查 tree-sitter parser 狀態
     - 檢查瀏覽器開啟工具
     - 提供清晰的錯誤訊息和解決建議
  ]]

  -- AC-01: 實作 :checkhealth 支援
  describe("AC-01: 實作 :checkhealth 支援", function()
    -- Cycle 1: 健康檢查模組存在性
    it("應該有健康檢查函數", function()
      -- Given: 我需要診斷 D2.nvim 狀態
      -- When: 我載入 health 模組
      -- Then: 應該有 check 函數可用
      
      local health = require("d2.health")
      
      assert.is_not_nil(health, "應該有 health 模組")
      assert.is_not_nil(health.check, "應該有 check 函數")
      assert.is_function(health.check, "check 應該是函數")
    end)
    
    -- Cycle 2: D2 CLI 檢查
    it("應該能檢查 D2 CLI 狀態", function()
      -- Given: 我需要檢查 D2 是否安裝
      -- When: 我呼叫健康檢查
      -- Then: 應該能正確回報 D2 狀態
      
      local health = require("d2.health")
      
      -- Mock vim.health
      local health_messages = {}
      _G.vim.health = {
        start = function(msg) table.insert(health_messages, {type = "start", message = msg}) end,
        ok = function(msg) table.insert(health_messages, {type = "ok", message = msg}) end,
        warn = function(msg, advice) table.insert(health_messages, {type = "warn", message = msg, advice = advice}) end,
        error = function(msg, advice) table.insert(health_messages, {type = "error", message = msg, advice = advice}) end,
        info = function(msg) table.insert(health_messages, {type = "info", message = msg}) end
      }
      
      -- 執行健康檢查
      health.check()
      
      -- 驗證有 D2 相關的檢查訊息
      local has_d2_check = false
      for _, msg in ipairs(health_messages) do
        if msg.message and msg.message:match("D2") then
          has_d2_check = true
          break
        end
      end
      
      assert.is_true(has_d2_check, "應該有 D2 CLI 相關的檢查")
    end)
    
    -- Cycle 3: Tree-sitter Parser 檢查
    it("應該能檢查 tree-sitter parser 狀態", function()
      -- Given: 我需要檢查 tree-sitter-d2 parser
      -- When: 我執行健康檢查
      -- Then: 應該回報 parser 狀態
      
      local health = require("d2.health")
      
      -- Mock vim.health
      local health_messages = {}
      _G.vim.health = {
        start = function(msg) table.insert(health_messages, {type = "start", message = msg}) end,
        ok = function(msg) table.insert(health_messages, {type = "ok", message = msg}) end,
        warn = function(msg, advice) table.insert(health_messages, {type = "warn", message = msg, advice = advice}) end,
        error = function(msg, advice) table.insert(health_messages, {type = "error", message = msg, advice = advice}) end,
        info = function(msg) table.insert(health_messages, {type = "info", message = msg}) end
      }
      
      -- 執行健康檢查
      health.check()
      
      -- 驗證有 tree-sitter 相關的檢查
      local has_treesitter_check = false
      for _, msg in ipairs(health_messages) do
        if msg.message and (msg.message:match("treesitter") or msg.message:match("parser")) then
          has_treesitter_check = true
          break
        end
      end
      
      assert.is_true(has_treesitter_check, "應該有 tree-sitter parser 相關的檢查")
    end)
    
    -- Cycle 4: 瀏覽器工具檢查
    it("應該能檢查瀏覽器開啟工具", function()
      -- Given: 我需要檢查瀏覽器開啟工具
      -- When: 我執行健康檢查
      -- Then: 應該回報瀏覽器工具狀態
      
      local health = require("d2.health")
      
      -- Mock vim.health
      local health_messages = {}
      _G.vim.health = {
        start = function(msg) table.insert(health_messages, {type = "start", message = msg}) end,
        ok = function(msg) table.insert(health_messages, {type = "ok", message = msg}) end,
        warn = function(msg, advice) table.insert(health_messages, {type = "warn", message = msg, advice = advice}) end,
        error = function(msg, advice) table.insert(health_messages, {type = "error", message = msg, advice = advice}) end,
        info = function(msg) table.insert(health_messages, {type = "info", message = msg}) end
      }
      
      -- 執行健康檢查
      health.check()
      
      -- 驗證有瀏覽器相關的檢查
      local has_browser_check = false
      for _, msg in ipairs(health_messages) do
        if msg.message and (msg.message:match("[Bb]rowser") or msg.message:match("opener")) then
          has_browser_check = true
          break
        end
      end
      
      assert.is_true(has_browser_check, "應該有瀏覽器開啟工具相關的檢查")
    end)
    
    -- 整合測試：完整健康檢查
    it("應該提供完整的診斷資訊", function()
      -- Given: 我需要完整的診斷資訊
      -- When: 我執行健康檢查
      -- Then: 應該包含所有必要的檢查項目
      
      local health = require("d2.health")
      
      -- Mock vim.health 並記錄所有訊息
      local health_messages = {}
      _G.vim.health = {
        start = function(msg) table.insert(health_messages, {type = "start", message = msg}) end,
        ok = function(msg) table.insert(health_messages, {type = "ok", message = msg}) end,
        warn = function(msg, advice) table.insert(health_messages, {type = "warn", message = msg, advice = advice}) end,
        error = function(msg, advice) table.insert(health_messages, {type = "error", message = msg, advice = advice}) end,
        info = function(msg) table.insert(health_messages, {type = "info", message = msg}) end
      }
      
      -- 執行健康檢查
      health.check()
      
      -- 驗證至少有一個 start 訊息
      local has_start = false
      for _, msg in ipairs(health_messages) do
        if msg.type == "start" then
          has_start = true
          break
        end
      end
      
      assert.is_true(has_start, "應該有開始訊息")
      assert.is_true(#health_messages > 3, "應該有多個檢查項目")
      
      -- 驗證有提供建議（當有 warn 或 error 時）
      for _, msg in ipairs(health_messages) do
        if msg.type == "warn" or msg.type == "error" then
          -- 如果有警告或錯誤，應該要有建議
          if msg.advice then
            assert.is_table(msg.advice, "建議應該是表格形式")
          end
        end
      end
    end)
  end)
end)