-- tests/test_story_003_treesitter.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("STORY-003: Tree-sitter 語法高亮", function()
  --[[
  STORY-003:
  As a Neovim 用戶
  I want to 在編輯 D2 檔案時有精確的語法高亮
  So that 我可以更清楚地閱讀和編寫 D2 圖表定義

  Acceptance Criteria:
  1. 安裝 tree-sitter-d2 parser
  2. 自動識別 .d2 檔案類型
  3. 基本高亮功能
  ]]

  -- AC-01: 安裝 tree-sitter-d2 parser
  describe("AC-01: 安裝 tree-sitter-d2 parser", function()
    -- Cycle 1/2: 模組存在性
    it("應該提供 tree-sitter 整合模組", function()
      -- Given: D2 plugin 已載入
      -- When: 檢查 treesitter 模組
      -- Then: 應該有 treesitter 模組可用
      
      -- 載入 plugin
      require("d2")
      
      -- 檢查 treesitter 模組是否存在
      local has_treesitter = pcall(require, "d2.treesitter")
      assert.is_true(has_treesitter, "d2.treesitter 模組應該存在")
      
      -- 如果模組存在，檢查基本功能
      if has_treesitter then
        local treesitter = require("d2.treesitter")
        assert.is_function(treesitter.setup, "應該有 setup 函數")
        assert.is_function(treesitter.ensure_d2_installed, "應該有 ensure_d2_installed 函數")
      end
    end)
    
    -- Cycle 2/2: 自動安裝功能
    it("應該能自動檢查並安裝 d2 parser", function()
      -- Given: treesitter 模組已載入
      -- When: 呼叫 ensure_d2_installed()
      -- Then: 應該檢查並嘗試安裝 parser
      
      -- Mock nvim-treesitter.parsers
      local has_parser_called = false
      package.loaded["nvim-treesitter.parsers"] = {
        has_parser = function(lang)
          has_parser_called = true
          return lang == "d2" and false  -- 模擬 parser 未安裝
        end
      }
      
      -- Mock vim.schedule 和 vim.cmd
      local scheduled_fn = nil
      local cmd_executed = nil
      vim.schedule = function(fn)
        scheduled_fn = fn
      end
      vim.cmd = function(cmd)
        cmd_executed = cmd
      end
      vim.notify = function() end  -- Mock notify
      
      -- 執行測試
      local treesitter = require("d2.treesitter")
      treesitter.ensure_d2_installed()
      
      -- 驗證檢查 parser
      assert.is_true(has_parser_called, "應該檢查 parser 是否已安裝")
      
      -- 驗證排程安裝
      assert.is_not_nil(scheduled_fn, "應該排程安裝任務")
      
      -- 執行排程的函數
      if scheduled_fn then
        scheduled_fn()
        assert.equals("TSInstall d2", cmd_executed, "應該執行 TSInstall d2 命令")
      end
    end)
  end)
  
  -- AC-02: 自動識別 .d2 檔案類型
  describe("AC-02: 自動識別 .d2 檔案類型", function()
    it("應該設定 .d2 檔案的 filetype", function()
      -- Given: D2 plugin 已載入
      -- When: 執行 setup
      -- Then: filetype 應該被設定
      
      -- Mock vim.filetype.add
      local filetype_config = nil
      vim = vim or {}
      vim.filetype = {
        add = function(config)
          filetype_config = config
        end
      }
      
      -- Mock nvim-treesitter
      package.loaded["nvim-treesitter.parsers"] = {
        has_parser = function() return true end
      }
      
      -- 執行 setup
      local treesitter = require("d2.treesitter")
      treesitter.setup()
      
      -- 驗證 filetype 設定
      assert.is_not_nil(filetype_config, "應該呼叫 vim.filetype.add")
      assert.is_not_nil(filetype_config.extension, "應該設定副檔名")
      assert.equals("d2", filetype_config.extension.d2, "應該將 .d2 對應到 d2 filetype")
    end)
  end)
  
  -- AC-03: 基本高亮功能
  describe("AC-03: 基本高亮功能", function()
    it("應該在 setup 時初始化 parser 支援", function()
      -- Given: treesitter 模組已載入
      -- When: 執行 setup
      -- Then: 應該確保 parser 安裝和 filetype 設定
      
      local ensure_called = false
      local filetype_added = false
      
      -- Mock functions
      vim.filetype = {
        add = function() filetype_added = true end
      }
      
      package.loaded["nvim-treesitter.parsers"] = {
        has_parser = function() return true end
      }
      
      -- 載入模組並執行 setup
      local treesitter = require("d2.treesitter")
      
      -- Override ensure_d2_installed to track calls
      local original_ensure = treesitter.ensure_d2_installed
      treesitter.ensure_d2_installed = function()
        ensure_called = true
        -- Call original if it exists
        if original_ensure then
          original_ensure()
        end
      end
      
      treesitter.setup()
      
      -- 驗證兩個功能都被呼叫
      assert.is_true(filetype_added, "應該設定 filetype")
      assert.is_true(ensure_called, "應該確保 parser 已安裝")
    end)
  end)
end)