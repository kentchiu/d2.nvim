## 開發參考

### 架構範本與最佳實踐
- https://github.com/ColinKennedy/nvim-best-practices-plugin-template : plugin 的 template
- https://github.com/nvim-neorocks/nvim-best-practices/blob/main/README.md : 開發時要遵循裡面的建議
- https://www.youtube.com/watch?v=rerTvidyz-0&ab_channel=senkwich : 把 CLI command 整合到 neovim 的方式

### 參考專案風格
開發的風格應該要類似我另外兩個 neovim 的 plugin:

**tmux-send.nvim** (主要參考)：
- 模組化 Lua 架構設計
- CLI 命令包裝與非同步執行
- 豐富的配置選項與預設值
- 完整的測試覆蓋

**aider.nvim**：
- AI 輔助編程工具整合
- 工作流程優化設計
- 終端與編輯器的無縫整合

### Tree-sitter 整合

**推薦使用**：`ravsii/tree-sitter-d2`
- 支援 D2 v0.6.9+ 最新功能
- 完整的語法高亮和折疊支援
- 針對 nvim-treesitter 優化
- 支援最新 D2 特性（globs, filters, variables）

**整合方式**：
```lua
-- 使用 nvim-treesitter 配置
require('nvim-treesitter.parsers').get_parser_configs().d2 = {
  install_info = {
    url = "https://github.com/ravsii/tree-sitter-d2",
    files = {"src/parser.c"},
    branch = "main"
  },
  filetype = "d2"
}
```

### CLI 功能最大化利用

**核心原則**：善用 D2 CLI 現有功能，不重新發明輪子

**主要 CLI 功能對應**：
- **Preview**: `d2 --watch` - 即時預覽功能
- **Export**: `d2 [input] [output] --format` - 多格式導出
- **Compile**: `d2 compile` - 語法檢查與編譯
- **Format**: `d2 fmt` - 程式碼格式化
- **Themes**: `d2 --theme` - 主題切換

**實現策略**：
- 使用 `vim.fn.jobstart()` 進行非同步執行
- 完整的錯誤處理與輸出捕獲
- 提供進度指示和執行狀態管理

### 編輯器功能策略

**優先使用 Tree-sitter**：
- 語法高亮：tree-sitter queries
- 程式碼導航：tree-sitter 節點遍歷
- 自動縮排：基於 tree-sitter 的智慧縮排
- 程式碼折疊：tree-sitter 語法感知折疊

**LSP 功能考慮**：
- 目前 D2 無官方 LSP server
- 可考慮未來整合第三方 LSP 實現
- 自動完成暫時依賴基於 tree-sitter 的上下文感知

