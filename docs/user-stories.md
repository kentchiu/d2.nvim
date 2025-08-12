# User Stories - D2.nvim

### STORY-001: 即時預覽功能

```
As a Neovim 用戶
I want to 在瀏覽器中即時預覽 D2 圖表
So that 我可以立即看到圖表的視覺效果
```

**Acceptance Criteria:**

- [x] **AC-01**: 啟動預覽伺服器
  - 使用 `d2 --watch` 命令啟動監控模式
  - 支援自動選擇可用埠號（`--port 0`）
  - 自動開啟預設瀏覽器（或使用 `--browser` 參數指定）

- [x] **AC-02**: 預覽控制指令
  - 提供 `:D2Preview` 啟動預覽
  - 提供 `:D2PreviewStop` 停止預覽
  - 顯示預覽 URL（如 localhost:54321）

- [x] **AC-03**: 檔案變更自動重載
  - D2 CLI 的 watch 模式已內建熱重載功能
  - 儲存檔案時自動觸發重新編譯

**技術限制**: D2 CLI 的 watch 模式本身已提供所需功能，無需額外實現

---

### STORY-002: 基本導出功能

```
As a Neovim 用戶
I want to 將當前 D2 檔案導出為 SVG/PNG
So that 我可以在文件或簡報中使用這些圖表
```

**Acceptance Criteria:**

- [x] **AC-01**: 導出為 SVG（預設）
  - 使用 `d2 file.d2 output.svg` 命令
  - SVG 為預設格式，無需指定
  - 支援 `--bundle` 選項打包所有資源

- [x] **AC-02**: 導出為 PNG
  - 使用 `d2 file.d2 output.png` 命令
  - 自動根據副檔名判斷格式
  - PNG 導出會自動添加附錄（tooltips 和 links）

- [x] **AC-03**: 導出指令介面
  - 提供 `:D2Export [format]` 指令
  - 預設導出到同目錄，檔名加上時間戳
  - 顯示導出成功訊息和檔案路徑

---

### STORY-003: Tree-sitter 語法高亮

```
As a Neovim 用戶
I want to 在編輯 D2 檔案時有精確的語法高亮
So that 我可以更清楚地閱讀和編寫 D2 圖表定義
```

**Acceptance Criteria:**

- [x] **AC-01**: 安裝 tree-sitter-d2 parser
  - 使用 ravsii/tree-sitter-d2（支援最新 D2 功能）
  - 透過 nvim-treesitter 安裝管理
  - 自動識別 .d2 檔案類型

- [x] **AC-02**: 配置 queries 檔案
  - 複製 highlights.scm 進行語法高亮
  - 複製 injections.scm 支援內嵌語言
  - 複製 locals.scm 追蹤局部變數

- [x] **AC-03**: 基本高亮功能
  - 節點、連線、屬性的不同顏色
  - 註解使用 `#` 符號
  - 字串和數值的區分

---

### STORY-004: 健康檢查功能

```
As a Neovim 用戶
I want to 診斷 D2.nvim 的安裝狀態
So that 我可以快速排除問題
```

**Acceptance Criteria:**

- [x] **AC-01**: 實作 :checkhealth 支援
  - 檢查 D2 CLI 是否安裝及版本
  - 檢查 tree-sitter parser 狀態
  - 檢查瀏覽器開啟工具
  - 提供清晰的錯誤訊息和解決建議

---

### STORY-005: 配置管理功能

```
As a Neovim 用戶
I want to 配置 D2 CLI 的偏好參數
So that 我可以根據需求自訂圖表的預設樣式和行為
```

**Acceptance Criteria:**

- [x] **AC-01**: 配置圖表佈局引擎
  - 支援配置預設 layout（dagre, elk, tala 等）
  - 透過 `setup({ layout = "dagre" })` 設定（預設值）
  - 在所有 D2 命令中使用 `--layout` 參數
  - 提供 `:D2SetLayout [layout]` 臨時切換

- [x] **AC-02**: 配置圖表風格
  - 支援 sketch 模式開關（手繪風格）
  - 透過 `setup({ sketch = false })` 設定（預設值）
  - 在預覽和導出時使用 `--sketch` 參數
  - 提供 `:D2ToggleSketch` 切換手繪風格

- [x] **AC-03**: 配置主題選擇
  - 支援內建主題配置（0-300+ 主題）
  - 透過 `setup({ theme = 101 })` 設定
  - 使用 `--theme` 參數套用主題
  - 提供 `:D2SetTheme [id]` 切換主題

- [x] **AC-04**: 配置進階選項
  - 支援 pad 設定（圖表邊距）
  - 支援 dark-theme 設定（深色主題ID）
  - 支援 force-appendix 設定（強制附錄）
  - 支援 animate-interval 設定（動畫間隔）

- [x] **AC-05**: 使用者級配置
  - 配置儲存於使用者的 Neovim 設定中
  - 透過 `require('d2').setup({...})` 進行配置
  - 提供 `:D2ShowConfig` 顯示當前配置
