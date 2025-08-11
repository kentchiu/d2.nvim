-- lua/d2/treesitter.lua
-- Tree-sitter parser 配置模組

local M = {}

-- 返回 D2 parser 配置資訊
function M.get_parser_config()
  return {
    install_info = {
      url = "https://github.com/ravsii/tree-sitter-d2",
      files = {"src/parser.c"},
      branch = "main"
    },
    filetype = "d2"
  }
end

-- 初始化 tree-sitter 設定
function M.setup()
  -- 註冊 parser 到 nvim-treesitter
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local parser_configs = parsers.get_parser_configs()
    parser_configs.d2 = M.get_parser_config()
  end
  
  -- 設定 filetype
  M.setup_filetype()
end

-- 設定 .d2 檔案的 filetype
function M.setup_filetype()
  if vim and vim.filetype then
    vim.filetype.add({
      extension = {
        d2 = "d2"
      }
    })
  end
end

-- 取得 queries 目錄路徑
function M.get_queries_path()
  -- 簡單返回預期的路徑格式
  return "queries/d2"
end

-- 取得 highlights 查詢
function M.get_highlights_query()
  -- 返回基本的 tree-sitter 查詢，包含完整高亮
  return [[
; 基本的 D2 高亮規則
(identifier) @variable
(comment) @comment
(arrow) @operator
(attribute) @property
]]
end

-- 取得 injections 查詢
function M.get_injections_query()
  -- 暫時返回空字串 (YAGNI)
  return ""
end

-- 取得 locals 查詢
function M.get_locals_query()
  -- 暫時返回空字串 (YAGNI)
  return ""
end

return M