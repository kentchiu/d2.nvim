-- tests/test_story_005_config.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("STORY-005: 配置管理功能", function()
  --[[
  As a Neovim 用戶
  I want to 配置 D2 CLI 的偏好參數
  So that 我可以根據需求自訂圖表的預設樣式和行為

  Acceptance Criteria:
  1. AC-01: 配置圖表佈局引擎
     - 支援配置預設 layout（dagre, elk, tala 等）
     - 透過 setup({ layout = "dagre" }) 設定（預設值）
     - 在所有 D2 命令中使用 --layout 參數
     - 提供 :D2SetLayout [layout] 臨時切換
  2. AC-02: 配置圖表風格
     - 支援 sketch 模式開關（手繪風格）
     - 透過 setup({ sketch = false }) 設定（預設值）
     - 在預覽和導出時使用 --sketch 參數
     - 提供 :D2ToggleSketch 切換手繪風格
  3. AC-03: 配置主題選擇
     - 支援內建主題配置（0-300+ 主題）
     - 透過 setup({ theme = 101 }) 設定
     - 使用 --theme 參數套用主題
     - 提供 :D2SetTheme [id] 切換主題
  4. AC-04: 配置進階選項
     - 支援 pad 設定（圖表邊距）
     - 支援 dark-theme 設定（深色主題ID）
     - 支援 force-appendix 設定（強制附錄）
     - 支援 animate-interval 設定（動畫間隔）
  5. AC-05: 使用者級配置
     - 配置儲存於使用者的 Neovim 設定中
     - 透過 require('d2').setup({...}) 進行配置
     - 提供 :D2ShowConfig 顯示當前配置
  ]]

  -- AC-01: 配置圖表佈局引擎
  describe("AC-01: 配置圖表佈局引擎", function()
    -- Cycle 1/4: 檢查配置模組存在性
    it("應該有配置模組可供設定", function()
      -- Given: 我是一個 Neovim 用戶想要配置 D2 plugin
      -- When: 我嘗試載入配置模組
      -- Then: 應該能夠成功載入配置模組
      
      local success, config = pcall(require, "d2.config")
      
      assert.is_true(success, "應該能夠載入 d2.config 模組")
      assert.is_not_nil(config, "配置模組不應為 nil")
      assert.is_table(config, "配置模組應該是一個 table")
    end)
    
    -- Cycle 2/4: 預設配置值
    it("應該有預設的 layout 配置", function()
      -- Given: 我載入了配置模組
      -- When: 我檢查預設配置
      -- Then: 應該有 layout 預設值為 'dagre'
      
      local config = require("d2.config")
      
      assert.is_not_nil(config.defaults, "應該有 defaults table")
      assert.is_table(config.defaults, "defaults 應該是 table")
      assert.equals("elk", config.defaults.layout, "預設 layout 應該是 'elk'")
    end)
    
    -- Cycle 3/4: Setup 函數
    it("應該能透過 setup 設定 layout", function()
      -- Given: 我有配置模組
      -- When: 我呼叫 setup 設定 layout 為 'elk'
      -- Then: 配置應該被更新
      
      local config = require("d2.config")
      
      -- 確認 setup 函數存在
      assert.is_not_nil(config.setup, "應該有 setup 函數")
      assert.is_function(config.setup, "setup 應該是函數")
      
      -- 設定自訂 layout
      config.setup({ layout = "elk" })
      
      -- 確認配置已更新
      assert.is_not_nil(config.options, "應該有 options table")
      assert.equals("elk", config.options.layout, "layout 應該被設為 'elk'")
    end)
    
    -- Cycle 4/4: CLI 命令整合
    it("應該將 layout 配置應用到 CLI 命令", function()
      -- Given: 我設定了 layout 為 'tala'
      -- When: 我建構 CLI 參數
      -- Then: 應該包含 --layout 參數
      
      local config = require("d2.config")
      config.setup({ layout = "tala" })
      
      -- 確認有 get_cli_args 函數
      assert.is_not_nil(config.get_cli_args, "應該有 get_cli_args 函數")
      assert.is_function(config.get_cli_args, "get_cli_args 應該是函數")
      
      -- 取得 CLI 參數
      local args = config.get_cli_args()
      assert.is_table(args, "應該返回參數陣列")
      
      -- 檢查是否包含 layout 參數
      local has_layout = false
      for i = 1, #args do
        if args[i] == "--layout" and args[i+1] == "tala" then
          has_layout = true
          break
        end
      end
      assert.is_true(has_layout, "應該包含 --layout tala 參數")
    end)
  end)
  
  -- AC-02: 配置圖表風格
  describe("AC-02: 配置圖表風格", function()
    -- Cycle 1/4: Sketch 配置支援
    it("應該有 sketch 模式配置", function()
      -- Given: 我載入了配置模組
      -- When: 我檢查預設配置
      -- Then: 應該有 sketch 預設值為 false
      
      local config = require("d2.config")
      
      assert.is_not_nil(config.defaults.sketch, "應該有 sketch 配置")
      assert.is_true(config.defaults.sketch, "預設 sketch 應該是 true")
    end)
    
    -- Cycle 2/4: Setup 接受 sketch 選項
    it("應該能透過 setup 設定 sketch", function()
      -- Given: 我有配置模組
      -- When: 我設定 sketch 為 true
      -- Then: 配置應該被更新
      
      local config = require("d2.config")
      config.setup({ sketch = true })
      
      assert.is_true(config.options.sketch, "sketch 應該被設為 true")
    end)
    
    -- Cycle 3/4: Toggle 功能
    it("應該能切換 sketch 模式", function()
      -- Given: 我有配置模組且 sketch 為 false
      -- When: 我呼叫 toggle_sketch
      -- Then: sketch 應該變為 true
      
      local config = require("d2.config")
      config.setup({ sketch = false })
      
      assert.is_not_nil(config.toggle_sketch, "應該有 toggle_sketch 函數")
      assert.is_function(config.toggle_sketch, "toggle_sketch 應該是函數")
      
      -- 切換 sketch
      config.toggle_sketch()
      assert.is_true(config.options.sketch, "sketch 應該變為 true")
      
      -- 再次切換
      config.toggle_sketch()
      assert.is_false(config.options.sketch, "sketch 應該變回 false")
    end)
    
    -- Cycle 4/4: 應用到 CLI
    it("應該將 sketch 配置應用到 CLI 命令", function()
      -- Given: 我設定了 sketch 為 true
      -- When: 我建構 CLI 參數
      -- Then: 應該包含 --sketch 參數
      
      local config = require("d2.config")
      config.setup({ sketch = true })
      
      local args = config.get_cli_args()
      
      -- 檢查是否包含 --sketch
      local has_sketch = false
      for _, arg in ipairs(args) do
        if arg == "--sketch" then
          has_sketch = true
          break
        end
      end
      assert.is_true(has_sketch, "應該包含 --sketch 參數")
    end)
  end)
  
  -- AC-03: 配置主題選擇
  describe("AC-03: 配置主題選擇", function()
    it("應該有 theme 配置", function()
      local config = require("d2.config")
      assert.equals(0, config.defaults.theme, "預設 theme 應該是 0")
    end)
    
    it("應該能設定和驗證 theme", function()
      local config = require("d2.config")
      
      -- 有效的 theme
      assert.is_true(config.set_theme(101), "應該接受有效的 theme ID")
      assert.equals(101, config.options.theme)
      
      -- 無效的 theme
      assert.is_false(config.set_theme(400), "應該拒絕超出範圍的 theme ID")
      assert.is_false(config.set_theme(-1), "應該拒絕負數 theme ID")
    end)
  end)
  
  -- AC-04: 配置進階選項
  describe("AC-04: 配置進階選項", function()
    it("應該有所有進階選項的預設值", function()
      local config = require("d2.config")
      assert.equals(100, config.defaults.pad, "預設 pad 應該是 100")
      assert.is_nil(config.defaults.dark_theme, "預設 dark_theme 應該是 nil")
      assert.is_false(config.defaults.force_appendix, "預設 force_appendix 應該是 false")
      assert.is_nil(config.defaults.animate_interval, "預設 animate_interval 應該是 nil")
    end)
    
    it("應該將進階選項應用到 CLI", function()
      local config = require("d2.config")
      config.setup({
        pad = 50,
        dark_theme = 200,
        force_appendix = true,
        animate_interval = 1000
      })
      
      local args = config.get_cli_args()
      local args_str = table.concat(args, " ")
      
      assert.is_true(args_str:match("--pad 50") ~= nil, "應該包含 pad 參數")
      assert.is_true(args_str:match("--dark%-theme 200") ~= nil, "應該包含 dark-theme 參數")
      assert.is_true(args_str:match("--force%-appendix") ~= nil, "應該包含 force-appendix 參數")
      assert.is_true(args_str:match("--animate%-interval 1000") ~= nil, "應該包含 animate-interval 參數")
    end)
  end)
  
  -- AC-05: 使用者級配置
  describe("AC-05: 使用者級配置", function()
    it("應該能取得當前配置", function()
      local config = require("d2.config")
      config.setup({ layout = "elk", theme = 101 })
      
      local current = config.get()
      assert.equals("elk", current.layout)
      assert.equals(101, current.theme)
    end)
    
    it("應該能顯示配置資訊", function()
      local config = require("d2.config")
      config.setup({ layout = "tala" })
      
      local info = config.show()
      assert.is_string(info)
      assert.is_true(info:match("D2.nvim Configuration") ~= nil)
      assert.is_true(info:match("layout: \"tala\"") ~= nil)
    end)
  end)
end)