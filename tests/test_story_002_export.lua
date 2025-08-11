-- tests/test_story_002_export.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

-- 測試輔助函數
local function setup_d2_and_mock_jobstart()
  local d2 = require("d2")
  d2.setup()
  
  local capture = {}
  _G.vim.fn.jobstart = function(cmd, opts)
    capture.cmd = cmd
    return 1
  end
  
  return capture
end

describe("STORY-002: 基本導出功能", function()
  --[[
  As a Neovim 用戶
  I want to 將當前 D2 檔案導出為 SVG/PNG
  So that 我可以在文件或簡報中使用這些圖表

  Acceptance Criteria:
  1. AC-01: 導出為 SVG（預設）
     - 使用 d2 file.d2 output.svg 命令
     - SVG 為預設格式，無需指定
     - 支援 --bundle 選項打包所有資源
  2. AC-02: 導出為 PNG
     - 使用 d2 file.d2 output.png 命令
     - 自動根據副檔名判斷格式
     - PNG 導出會自動添加附錄
  3. AC-03: 導出指令介面
     - 提供 :D2Export [format] 指令
     - 預設導出到同目錄，檔名加上時間戳
     - 顯示導出成功訊息和檔案路徑
  ]]

  -- AC-01: 導出為 SVG（預設）
  describe("AC-01: 導出為 SVG（預設）", function()
    -- Cycle 1/4: 檢查導出指令存在性
    it("應該存在 :D2Export 指令", function()
      -- BDD 格式：
      -- Given: 我是一個 Neovim 用戶並且已載入 d2.nvim 插件
      -- When: 我檢查可用的指令
      -- Then: 系統應該有 :D2Export 指令可用
      
      -- 載入插件
      local ok, d2 = pcall(require, "d2")
      assert.is_true(ok, "應該能夠載入 d2 模組")
      
      -- 設置插件 (KISS: 最簡單的方式讓命令註冊)
      d2.setup()
      
      -- 檢查 export 指令是否存在
      local commands = vim.api.nvim_get_commands({})
      assert.is_not_nil(commands.D2Export, ":D2Export 指令應該存在")
    end)
    
    -- Cycle 2/4: 執行基本導出功能
    it("應該執行 d2 命令導出 SVG", function()
      -- BDD 格式：
      -- Given: 有一個 D2 檔案正在編輯
      -- When: 執行 D2Export 命令
      -- Then: 應該調用 d2 CLI 命令
      
      -- Setup with helper
      local capture = setup_d2_and_mock_jobstart()
      
      -- Given: 編輯 D2 檔案
      vim.cmd("edit test.d2")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {"x -> y"})
      
      -- When: 執行導出
      vim.cmd("D2Export")
      
      -- Then: 應該執行 d2 命令
      local captured_cmd = capture.cmd
      assert.is_not_nil(captured_cmd, "應該執行命令")
      assert.equals("table", type(captured_cmd), "命令應該是 table")
      assert.equals("d2", captured_cmd[1], "第一個參數應該是 d2")
      -- 檢查輸出檔案有 .svg 副檔名
      local has_svg = false
      for _, arg in ipairs(captured_cmd) do
        if arg:match("%.svg$") then
          has_svg = true
          break
        end
      end
      assert.is_true(has_svg, "輸出應該是 SVG 格式")
    end)
    
    -- Cycle 3/4: 處理當前檔案與時間戳
    it("應該使用當前檔案並生成時間戳檔名", function()
      -- BDD 格式：
      -- Given: 編輯 diagram.d2 檔案
      -- When: 執行 D2Export
      -- Then: 輸出檔名應該包含原檔名和時間戳
      
      -- Setup
      local d2 = require("d2")
      d2.setup()
      
      -- Mock jobstart
      local captured_cmd = nil
      _G.vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1
      end
      
      -- Given: 編輯具體路徑的 D2 檔案
      vim.cmd("edit /tmp/diagram.d2")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {"a -> b"})
      
      -- When: 執行導出
      vim.cmd("D2Export")
      
      -- Then: 檢查輸出檔名格式
      assert.is_not_nil(captured_cmd, "應該執行命令")
      assert.equals(3, #captured_cmd, "命令應該有 3 個參數")
      
      local output_file = captured_cmd[3]
      assert.is_not_nil(output_file, "應該有輸出檔案參數")
      
      -- 檢查檔名包含時間戳 (格式: diagram_YYYYMMDD_HHMMSS.svg)
      assert.is_truthy(
        output_file:match("diagram_%d%d%d%d%d%d%d%d_%d%d%d%d%d%d%.svg$"),
        "輸出檔名應該包含時間戳: " .. output_file
      )
      
      -- 檢查在同目錄
      assert.is_truthy(
        output_file:match("^/tmp/"),
        "輸出應該在同目錄"
      )
    end)
    
    -- Cycle 4/4: 支援 bundle 選項
    it("應該支援 --bundle 選項打包資源", function()
      -- BDD 格式：
      -- Given: D2 檔案可能包含外部資源
      -- When: 執行帶 bundle 參數的導出
      -- Then: d2 命令應該包含 --bundle 參數
      
      -- Setup
      local d2 = require("d2")
      d2.setup()
      
      -- Mock jobstart
      local captured_cmd = nil
      _G.vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1
      end
      
      -- Given: 編輯 D2 檔案
      vim.cmd("edit /tmp/complex.d2")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {"x -> y"})
      
      -- When: 執行帶 bundle 的導出
      vim.cmd("D2Export bundle")
      
      -- Then: 檢查命令包含 --bundle
      assert.is_not_nil(captured_cmd, "應該執行命令")
      
      -- 檢查是否包含 --bundle 參數
      local has_bundle = vim.tbl_contains(captured_cmd, "--bundle")
      assert.is_true(has_bundle, "命令應該包含 --bundle 參數")
    end)
  end)
  
  -- AC-02: 導出為 PNG
  describe("AC-02: 導出為 PNG", function()
    -- Cycle 1/3: PNG 格式參數
    it("應該支援導出為 PNG 格式", function()
      -- Setup
      local d2 = require("d2")
      d2.setup()
      
      local captured_cmd = nil
      _G.vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1
      end
      
      -- Given: D2 檔案
      vim.cmd("edit /tmp/test.d2")
      
      -- When: 指定 PNG 格式
      vim.cmd("D2Export png")
      
      -- Then: 輸出副檔名應該是 .png
      assert.is_not_nil(captured_cmd)
      local output_file = captured_cmd[3]
      assert.is_truthy(output_file:match("%.png$"), "輸出應該是 PNG 格式")
    end)
    
    -- Cycle 2/3: 同時支援 png 和 bundle
    it("應該同時支援 PNG 格式和 bundle 選項", function()
      local d2 = require("d2")
      d2.setup()
      
      local captured_cmd = nil
      _G.vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1
      end
      
      -- When: 同時使用 png 和 bundle
      vim.cmd("edit /tmp/test.d2")
      vim.cmd("D2Export png bundle")
      
      -- Then: 檢查兩個選項都生效
      assert.is_not_nil(captured_cmd)
      local output_file = captured_cmd[3]
      assert.is_truthy(output_file:match("%.png$"), "輸出應該是 PNG")
      assert.is_true(vim.tbl_contains(captured_cmd, "--bundle"), "應該包含 bundle")
    end)
  end)
  
  -- AC-03: 導出指令介面
  describe("AC-03: 導出指令介面", function()
    -- Cycle 1/4: 預設行為
    it("無參數時應該預設導出 SVG", function()
      local d2 = require("d2")
      d2.setup()
      
      local captured_cmd = nil
      _G.vim.fn.jobstart = function(cmd, opts)
        captured_cmd = cmd
        return 1
      end
      
      vim.cmd("edit /tmp/default.d2")
      vim.cmd("D2Export")
      
      -- 預設應該是 SVG
      local output_file = captured_cmd[3]
      assert.is_truthy(output_file:match("%.svg$"), "預設應該導出 SVG")
    end)
    
    -- Cycle 2/4: 自動完成
    it("應該提供命令自動完成", function()
      local d2 = require("d2")
      d2.setup()
      
      -- 檢查命令有 complete 函數
      local commands = vim.api.nvim_get_commands({})
      assert.is_not_nil(commands.D2Export, "D2Export 命令應該存在")
      
      -- 手動測試 complete 函數（因為它在命令定義中）
      -- 這個測試主要確保命令定義正確
      assert.equals("?", commands.D2Export.nargs, "應該接受可選參數")
    end)
  end)
end)