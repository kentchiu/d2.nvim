# User Stories - D2.nvim

基於 D2 CLI v0.7.0 實際功能和 tree-sitter-d2 能力重新設計的用戶故事。

## Phase 1: MVP (基礎功能)

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

### STORY-006: 檔案類型設定

```
As a Neovim 用戶
I want to D2 檔案有正確的編輯器設定
So that 編輯體驗符合 D2 的慣例
```

**Acceptance Criteria:**

- [ ] **AC-01**: 自動識別檔案類型
  - 識別 `.d2` 副檔名
  - 設定 filetype 為 `d2`
  - 載入對應的 ftplugin 設定

- [ ] **AC-02**: 基本編輯器設定
  - 註解字串設為 `# %s`
  - 縮排寬度預設 2 空格
  - 使用空格而非 Tab

- [ ] **AC-03**: 基礎按鍵綁定
  - `<leader>dp` 啟動預覽
  - `<leader>de` 導出圖表
  - `<leader>ds` 停止預覽

---

## Phase 2: 核心功能完善

### STORY-007: 程式碼格式化

```
As a Neovim 用戶
I want to 自動格式化 D2 程式碼
So that 我的圖表定義保持一致的程式碼風格
```

**Acceptance Criteria:**

- [ ] **AC-01**: 執行格式化
  - 使用 `d2 fmt file.d2` 命令
  - 支援就地格式化（覆寫原檔）
  - 處理格式化錯誤

- [ ] **AC-02**: 格式化指令
  - 提供 `:D2Format` 命令
  - 可整合到 `formatprg` 設定
  - 支援視覺模式選擇區域格式化

- [ ] **AC-03**: 格式檢查模式
  - 使用 `d2 fmt --check` 檢查格式
  - 不修改檔案，只報告問題
  - 可用於 CI/CD 流程

---

### STORY-008: 主題切換功能

```
As a Neovim 用戶
I want to 切換 D2 圖表的視覺主題
So that 我可以選擇適合不同場景的圖表樣式
```

**Acceptance Criteria:**

- [ ] **AC-01**: 列出可用主題
  - 使用 `d2 themes` 列出所有主題
  - 顯示主題 ID 和名稱
  - 提供主題選擇介面

- [ ] **AC-02**: 設定主題
  - 使用 `--theme` 參數指定主題 ID
  - 支援亮色/暗色模式（`--dark-theme`）
  - 在預覽和導出時套用主題

- [ ] **AC-03**: 主題持久化
  - 記住用戶選擇的主題
  - 支援專案級別的主題配置
  - 提供 `:D2Theme [id]` 命令

---

### STORY-009: 佈局引擎選擇

```
As a Neovim 用戶
I want to 選擇不同的佈局引擎
So that 我可以為不同類型的圖表選擇最佳佈局
```

**Acceptance Criteria:**

- [ ] **AC-01**: 列出佈局引擎
  - 使用 `d2 layout` 列出可用引擎
  - 顯示每個引擎的簡短說明
  - 預設使用 dagre 引擎

- [ ] **AC-02**: 查看引擎詳情
  - 使用 `d2 layout [name]` 查看詳細說明
  - 顯示引擎的配置選項
  - 提供使用建議

- [ ] **AC-03**: 設定佈局引擎
  - 使用 `--layout` 參數指定引擎
  - 提供 `:D2Layout [engine]` 命令
  - 支援專案級別的引擎配置

---

### STORY-010: 錯誤診斷整合

```
As a Neovim 用戶
I want to 看到 D2 語法錯誤的即時提示
So that 我可以快速修正問題
```

**Acceptance Criteria:**

- [ ] **AC-01**: 語法驗證
  - 使用 `d2 validate file.d2` 檢查語法
  - 在儲存時自動執行驗證
  - 使用非同步執行避免阻塞

- [ ] **AC-02**: 錯誤顯示
  - 解析 D2 CLI 的錯誤輸出
  - 轉換為 Neovim 診斷格式
  - 在對應行顯示錯誤標記

- [ ] **AC-03**: 錯誤導航
  - 使用 `]d` / `[d` 跳轉錯誤
  - 顯示錯誤詳情在浮動視窗
  - 整合到 quickfix 列表

## Phase 3: 進階功能

### STORY-011: 手繪風格切換

```
As a Neovim 用戶
I want to 切換到手繪風格
So that 我的圖表看起來更加親切和非正式
```

**Acceptance Criteria:**

- [ ] **AC-01**: 啟用手繪模式
  - 使用 `--sketch` 參數
  - 提供 `:D2Sketch` 切換命令
  - 在預覽和導出時都支援

- [ ] **AC-02**: 手繪風格配置
  - 記住用戶的風格偏好
  - 支援專案級別配置
  - 提供快速切換按鍵

---

### STORY-012: Tree-sitter 程式碼折疊

```
As a Neovim 用戶
I want to 折疊 D2 程式碼區塊
So that 我可以專注於當前編輯的部分
```

**Acceptance Criteria:**

- [ ] **AC-01**: 基於語法樹的折疊
  - 使用 tree-sitter 節點定義折疊點
  - 支援巢狀結構的多層折疊
  - 提供 folds.scm 查詢檔案

- [ ] **AC-02**: 折疊操作
  - 使用標準 Vim 折疊命令（za, zo, zc）
  - 支援折疊層級控制（zr, zm）
  - 保持折疊狀態（使用 viewoptions）

---

### STORY-013: 多板塊動畫導出

```
As a Neovim 用戶
I want to 將多個板塊導出為動畫 SVG
So that 我可以展示漸進式的圖表變化
```

**Acceptance Criteria:**

- [ ] **AC-01**: 動畫 SVG 導出
  - 使用 `--animate-interval` 參數
  - 設定每個板塊的顯示時間（毫秒）
  - 僅支援 SVG 格式

- [ ] **AC-02**: 動畫控制
  - 提供 `:D2Animate [interval]` 命令
  - 預設間隔時間（如 2000ms）
  - 預覽動畫效果

---

### STORY-014: 自訂字體支援

```
As a Neovim 用戶
I want to 使用自訂字體
So that 圖表符合我的品牌視覺規範
```

**Acceptance Criteria:**

- [ ] **AC-01**: 指定字體檔案
  - 支援 `--font-regular` 參數
  - 支援 `--font-bold` 參數
  - 支援 `--font-italic` 參數
  - 支援 `--font-semibold` 參數

- [ ] **AC-02**: 字體配置管理
  - 提供配置選項設定字體路徑
  - 支援專案級別的字體設定
  - 驗證字體檔案存在性

---

### STORY-015: 圖表縮放控制

```
As a Neovim 用戶
I want to 控制導出圖表的大小
So that 我可以產生適合不同用途的圖表尺寸
```

**Acceptance Criteria:**

- [ ] **AC-01**: 縮放比例設定
  - 使用 `--scale` 參數（如 0.5, 2.0）
  - 預設 -1 表示 SVG 自適應螢幕
  - 設為 1 關閉 SVG 自適應

- [ ] **AC-02**: 邊距控制
  - 使用 `--pad` 參數設定邊距（像素）
  - 預設 100 像素邊距
  - 支援配置預設邊距

- [ ] **AC-03**: 置中選項
  - 使用 `--center` 參數置中 SVG
  - 在 viewbox 中置中顯示
  - 適合簡報和文件嵌入

## 實現優先級說明

### 必須依賴 D2 CLI 的功能

- 預覽（watch 模式）
- 導出（各種格式）
- 格式化（fmt）
- 驗證（validate）
- 主題和佈局引擎

### 必須依賴 Tree-sitter 的功能

- 語法高亮
- 程式碼折疊
- 智慧縮排
- 符號導航

### 不在當前範圍內的功能

- 自動完成（需要 LSP server，D2 尚無官方支援）
- 智慧重構（需要語意分析）
- 即時錯誤修正建議（需要更深入的語法理解）

## 技術限制說明

1. **D2 CLI 限制**：
   - validate 命令只做基本語法檢查
   - fmt 命令無法格式化部分選擇區域
   - 無 LSP server，無法提供語意級別的功能

2. **Tree-sitter 限制**：
   - ravsii/tree-sitter-d2 仍在開發中
   - 某些複雜語法可能尚未完全支援
   - 需要手動複製 queries 檔案

3. **整合挑戰**：
   - 需要處理不同平台的路徑差異
   - 瀏覽器自動開啟在某些環境可能失效
   - 非同步執行需要妥善的錯誤處理

