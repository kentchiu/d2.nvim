# D2.nvim 架構設計

## 專案目錄結構

```
d2.nvim/
├── lua/d2/
│   ├── init.lua          # 主模組入口點
│   ├── config.lua        # 配置管理
│   ├── cli.lua           # D2 CLI 包裝模組
│   ├── preview.lua       # 預覽功能模組
│   ├── export.lua        # 導出功能模組
│   ├── treesitter.lua    # Tree-sitter 整合
│   ├── diagnostics.lua   # 診斷與錯誤處理
│   ├── format.lua        # 程式碼格式化
│   ├── theme.lua         # 主題管理
│   └── utils.lua         # 工具函數
├── plugin/
│   └── d2.lua            # Vim 命令定義與自動命令
├── queries/d2/           # Tree-sitter 查詢檔案
│   ├── highlights.scm    # 語法高亮規則
│   ├── injections.scm    # 程式碼注入規則
│   ├── locals.scm        # 局部變數定義
│   └── folds.scm         # 程式碼折疊規則
├── ftplugin/
│   └── d2.lua            # D2 檔案類型特定設定
├── syntax/
│   └── d2.vim            # 備用語法檔案（fallback）
├── tests/
│   ├── d2/               # 模組單元測試
│   ├── fixtures/         # 測試用 D2 檔案
│   └── spec_helper.lua   # 測試輔助函數
├── docs/
│   ├── architecture.md   # 此檔案
│   ├── development-principles.md
│   ├── project-plan.md
│   └── user-stories.md
├── scripts/
│   ├── install-parser.lua # Tree-sitter parser 安裝腳本
│   └── setup-dev.sh      # 開發環境設置
├── CLAUDE.md             # 開發指南
├── README.md             # 專案說明
└── Makefile             # 開發任務自動化
```

## 核心模組架構

### 1. 主模組 (lua/d2/init.lua)

```lua
-- 模組入口點，提供統一的 API 介面
local M = {}

M.setup = function(opts)
  -- 初始化配置
  -- 設置 tree-sitter
  -- 註冊命令和自動命令
end

M.preview = require('d2.preview')
M.export = require('d2.export')
M.format = require('d2.format')
M.theme = require('d2.theme')

return M
```

### 2. 配置管理 (lua/d2/config.lua)

```lua
-- 統一的配置管理系統
local M = {}

M.defaults = {
  -- CLI 相關配置
  cli = {
    d2_bin = "d2",
    timeout = 30000,
  },
  -- 預覽配置
  preview = {
    auto_open_browser = true,
    port = 0, -- 自動選擇埠號
    theme = "default",
  },
  -- 導出配置
  export = {
    default_format = "svg",
    output_dir = "./exports",
  },
  -- Tree-sitter 配置
  treesitter = {
    auto_install = true,
    highlight = true,
    indent = true,
  }
}

M.setup = function(user_config)
  -- 合併用戶配置與預設配置
end

return M
```

### 3. CLI 包裝模組 (lua/d2/cli.lua)

```lua
-- D2 CLI 命令包裝與執行
local M = {}

-- 非同步執行 D2 命令
M.exec_async = function(args, callback, opts)
  -- 使用 vim.fn.jobstart() 執行
  -- 處理 stdout/stderr
  -- 錯誤處理和重試機制
end

-- 檢查 D2 CLI 是否可用
M.check_binary = function()
  -- 檢查 d2 binary 是否存在
  -- 檢查版本相容性
end

-- 具體命令包裝
M.preview_start = function(file, opts)
M.export = function(input, output, format, opts)
M.format = function(file, opts)
M.compile = function(file, opts)

return M
```

### 4. 預覽功能模組 (lua/d2/preview.lua)

```lua
-- 即時預覽功能實現
local M = {}

-- 狀態管理
local preview_state = {
  job_id = nil,
  port = nil,
  is_running = false,
}

M.start = function(file, opts)
  -- 啟動 d2 --watch
  -- 開啟瀏覽器
  -- 管理預覽狀態
end

M.stop = function()
  -- 停止預覽進程
  -- 清理狀態
end

M.status = function()
  -- 返回預覽狀態
end

return M
```

### 5. Tree-sitter 整合 (lua/d2/treesitter.lua)

```lua
-- Tree-sitter 功能整合
local M = {}

M.setup_parser = function()
  -- 設置 tree-sitter-d2 parser
  -- 配置 queries
end

M.get_node_at_cursor = function()
  -- 獲取游標位置的語法節點
end

M.get_document_symbols = function()
  -- 獲取文件符號列表（用於導航）
end

M.fold_expr = function()
  -- 基於 tree-sitter 的折疊表達式
end

return M
```

## 命令與自動命令架構

### Vim 命令定義 (plugin/d2.lua)

```vim
" 主要命令
command! -nargs=? D2Preview lua require('d2').preview.start(<f-args>)
command! D2PreviewStop lua require('d2').preview.stop()
command! -nargs=? -complete=file D2Export lua require('d2').export.run(<f-args>)
command! D2Format lua require('d2').format.run()
command! -nargs=? D2Theme lua require('d2').theme.set(<f-args>)

" 自動命令
augroup D2Nvim
  autocmd!
  autocmd FileType d2 lua require('d2').setup_buffer()
  autocmd BufWritePost *.d2 lua require('d2').on_file_save()
augroup END
```

### 檔案類型設定 (ftplugin/d2.lua)

```lua
-- D2 檔案特定設定
vim.bo.commentstring = "# %s"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

-- 設置 tree-sitter 高亮
if vim.fn.exists('+syntax') == 1 then
  vim.cmd('TSBufEnable highlight')
end

-- 設置按鍵綁定
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>dp', '<cmd>D2Preview<cr>', opts)
vim.keymap.set('n', '<leader>de', '<cmd>D2Export<cr>', opts)
vim.keymap.set('n', '<leader>df', '<cmd>D2Format<cr>', opts)
```

## 資料流程架構

### 預覽工作流程

```
用戶觸發預覽
    ↓
檢查 D2 CLI 可用性
    ↓
啟動 d2 --watch 進程
    ↓
捕獲輸出（埠號等）
    ↓
開啟瀏覽器至預覽 URL
    ↓
監控進程狀態
    ↓
檔案變更時自動重新載入
```

### 導出工作流程

```
用戶觸發導出
    ↓
確認輸出路徑和格式
    ↓
執行 d2 export 命令
    ↓
監控導出進度
    ↓
處理成功/錯誤結果
    ↓
顯示完成狀態
```

### 錯誤處理架構

```
CLI 執行錯誤
    ↓
捕獲 stderr 輸出
    ↓
解析錯誤訊息
    ↓
轉換為 Neovim 診斷格式
    ↓
顯示在診斷視窗
    ↓
提供修正建議（如果可能）
```

## Tree-sitter 整合架構

### Query 檔案結構

- **highlights.scm**: 語法高亮規則
- **injections.scm**: 其他語言程式碼注入（如 markdown 中的 D2）
- **locals.scm**: 變數和作用域定義
- **folds.scm**: 程式碼折疊邏輯

### 語法功能實現

1. **語法高亮**: 基於 tree-sitter queries 的精確高亮
2. **智慧縮排**: 根據語法樹結構的自動縮排
3. **程式碼導航**: 基於語法節點的跳轉功能
4. **符號搜索**: 提取文件中的符號用於快速導航

## 測試架構

### 測試分類

1. **單元測試**: 各模組功能測試
2. **整合測試**: CLI 整合和工作流程測試
3. **端到端測試**: 完整功能流程測試

### 測試環境

- 使用 `plenary.nvim` 作為測試框架
- 提供測試用 D2 檔案 fixtures
- 模擬 CLI 執行環境
- 自動化測試執行

## 效能考量

1. **非同步執行**: 所有 CLI 操作使用非同步執行
2. **快取機制**: 快取編譯結果和狀態資訊
3. **延遲載入**: 按需載入模組功能
4. **資源管理**: 適當清理進程和暫存檔案

## 相依性管理

### 必需相依性

- `nvim-treesitter`: Tree-sitter 功能支援
- `plenary.nvim`: 非同步和工具函數

### 外部相依性

- `d2` CLI binary
- 現代瀏覽器（用於預覽）

