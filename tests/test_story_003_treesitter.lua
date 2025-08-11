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
  2. 配置 queries 檔案
  3. 基本高亮功能
  ]]

  -- AC-01: 安裝 tree-sitter-d2 parser
  describe("AC-01: 安裝 tree-sitter-d2 parser", function()
    -- Cycle 1/3: Parser 配置存在性
    it("應該提供 tree-sitter-d2 parser 配置", function()
      -- Given: D2 plugin 已載入
      -- When: 檢查 treesitter 模組
      -- Then: 應該有 parser 配置模組可用
      
      -- 載入 plugin
      require("d2")
      
      -- 檢查 treesitter 配置模組是否存在
      local has_treesitter_config = pcall(require, "d2.treesitter")
      assert.is_true(has_treesitter_config, "d2.treesitter 模組應該存在")
      
      -- 如果模組存在，檢查配置
      if has_treesitter_config then
        local treesitter = require("d2.treesitter")
        assert.is_function(treesitter.setup, "應該有 setup 函數來配置 parser")
        
        -- 檢查 parser 配置
        local config = treesitter.get_parser_config()
        assert.is_not_nil(config, "應該提供 parser 配置")
        assert.equals("https://github.com/ravsii/tree-sitter-d2", 
                      config.install_info.url, 
                      "應該使用 ravsii/tree-sitter-d2 parser")
      end
    end)
    
    -- Cycle 2/3: Parser 安裝功能
    it("應該能夠註冊 parser 到 nvim-treesitter", function()
      -- Given: nvim-treesitter 可用
      -- When: 呼叫 setup() 函數
      -- Then: parser 應該被註冊到 nvim-treesitter
      
      -- 準備 mock 或使用真實的 nvim-treesitter
      local parser_configs = {}
      package.loaded["nvim-treesitter.parsers"] = {
        get_parser_configs = function()
          return parser_configs
        end
      }
      
      -- 載入並執行 setup
      local treesitter = require("d2.treesitter")
      treesitter.setup()
      
      -- 驗證 parser 被註冊
      assert.is_not_nil(parser_configs.d2, "d2 parser 應該被註冊到 nvim-treesitter")
      
      if parser_configs.d2 then
        assert.equals("https://github.com/ravsii/tree-sitter-d2",
                      parser_configs.d2.install_info.url,
                      "應該使用正確的 parser URL")
        assert.equals("d2", parser_configs.d2.filetype, "應該關聯到 d2 filetype")
      end
    end)
    
    -- Cycle 3/3: Filetype 關聯
    it("應該設定 .d2 檔案的 filetype", function()
      -- Given: D2 plugin 已載入
      -- When: 開啟 .d2 檔案
      -- Then: filetype 應該被設為 "d2"
      
      local treesitter = require("d2.treesitter")
      
      -- 檢查是否有 filetype 設定函數
      assert.is_function(treesitter.setup_filetype, "應該有 setup_filetype 函數")
      
      -- Mock vim.filetype.add 函數
      local filetype_config = nil
      vim = vim or {}
      vim.filetype = {
        add = function(config)
          filetype_config = config
        end
      }
      
      -- 執行 filetype 設定
      treesitter.setup_filetype()
      
      -- 驗證 filetype 設定
      assert.is_not_nil(filetype_config, "應該呼叫 vim.filetype.add")
      assert.is_not_nil(filetype_config.extension, "應該設定副檔名")
      assert.equals("d2", filetype_config.extension.d2, "應該將 .d2 對應到 d2 filetype")
    end)
  end)
  
  -- AC-02: 配置 queries 檔案
  describe("AC-02: 配置 queries 檔案", function()
    -- Cycle 1/3: Queries 目錄結構
    it("應該提供 queries 目錄路徑", function()
      -- Given: treesitter 模組已載入
      -- When: 查詢 queries 路徑
      -- Then: 應該返回正確的路徑
      
      local treesitter = require("d2.treesitter")
      
      -- 檢查是否有取得 queries 路徑的函數
      assert.is_function(treesitter.get_queries_path, "應該有 get_queries_path 函數")
      
      -- 取得 queries 路徑
      local queries_path = treesitter.get_queries_path()
      assert.is_string(queries_path, "應該返回 queries 路徑字串")
      assert.truthy(queries_path:match("queries/d2$"), "路徑應該包含 queries/d2")
    end)
    
    -- Cycle 2/3: Highlights.scm 配置
    it("應該載入 highlights.scm 查詢", function()
      -- Given: treesitter 模組已載入
      -- When: 取得 highlights 查詢
      -- Then: 應該返回基本的高亮規則
      
      local treesitter = require("d2.treesitter")
      
      -- 檢查是否有取得 highlights 查詢的函數
      assert.is_function(treesitter.get_highlights_query, "應該有 get_highlights_query 函數")
      
      -- 取得 highlights 查詢
      local highlights = treesitter.get_highlights_query()
      assert.is_string(highlights, "應該返回 highlights 查詢字串")
      
      -- 驗證包含基本的高亮規則
      assert.truthy(highlights:match("@"), "應該包含 tree-sitter 查詢語法")
    end)
    
    -- Cycle 3/3: 其他 queries 檔案
    it("應該載入 injections 和 locals 查詢", function()
      -- Given: treesitter 模組已載入
      -- When: 取得其他查詢檔案
      -- Then: 應該返回對應的查詢內容
      
      local treesitter = require("d2.treesitter")
      
      -- 檢查 injections 查詢
      assert.is_function(treesitter.get_injections_query, "應該有 get_injections_query 函數")
      local injections = treesitter.get_injections_query()
      assert.is_string(injections, "應該返回 injections 查詢字串")
      
      -- 檢查 locals 查詢
      assert.is_function(treesitter.get_locals_query, "應該有 get_locals_query 函數")
      local locals = treesitter.get_locals_query()
      assert.is_string(locals, "應該返回 locals 查詢字串")
    end)
  end)
  
  -- AC-03: 基本高亮功能
  describe("AC-03: 基本高亮功能", function()
    -- Cycle 1/3: 節點高亮
    it("應該定義節點的高亮規則", function()
      -- Given: highlights 查詢已載入
      -- When: 檢查高亮規則
      -- Then: 應該包含節點相關的高亮
      
      local treesitter = require("d2.treesitter")
      local highlights = treesitter.get_highlights_query()
      
      -- 驗證有節點相關的高亮規則
      assert.truthy(highlights:match("identifier") or highlights:match("node"), 
                    "應該包含節點高亮規則")
    end)
    
    -- Cycle 2/3: 連線高亮
    it("應該定義連線的高亮規則", function()
      -- Given: highlights 查詢已載入
      -- When: 檢查高亮規則
      -- Then: 應該包含連線相關的高亮
      
      local treesitter = require("d2.treesitter")
      local highlights = treesitter.get_highlights_query()
      
      -- 驗證有連線相關的高亮規則
      assert.truthy(highlights:match("arrow") or highlights:match("edge") or highlights:match("->"), 
                    "應該包含連線高亮規則")
    end)
    
    -- Cycle 3/3: 屬性高亮
    it("應該定義屬性和註解的高亮規則", function()
      -- Given: highlights 查詢已載入
      -- When: 檢查高亮規則
      -- Then: 應該包含屬性相關的高亮
      
      local treesitter = require("d2.treesitter")
      local highlights = treesitter.get_highlights_query()
      
      -- 驗證有註解的高亮規則
      assert.truthy(highlights:match("comment"), "應該包含註解高亮規則")
      
      -- 驗證有屬性相關的高亮規則
      assert.truthy(highlights:match("attribute") or highlights:match("property") or highlights:match("style"),
                    "應該包含屬性高亮規則")
    end)
  end)
end)