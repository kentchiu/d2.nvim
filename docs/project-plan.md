# D2 Neovim Plugin - 專案規劃問卷

請在每個問題下方填寫你的答案。完成後存檔，我會自動處理這些資訊。

## 1. 專案動機

### 為什麼要做這個 D2 neovim plugin？

> 現有的 D2 工具與 neovim 整合不夠好、想要更流暢的編輯體驗

## 2. 目標用戶

### 主要使用者是誰？他們的核心需求是什麼？

> （請列出 3-5 個核心需求）
>
> - D2 preview
> - D2 svg,png export
> - D2 syntax highlight
> - D2 code assist

## 3. 核心功能（MVP）

請標記必要功能 [x] 和期望功能 [ ]：

### 編輯功能

- [x] 語法高亮 (Syntax highlighting)
- [x] 自動縮排 (Auto-indent)
- [ ] 程式碼折疊 (Code folding)
- [x] 語法檢查 (Linting)

### 預覽功能

- [x] 即時預覽 (Live preview in browser)
- [ ] 預覽視窗分割 (Split window preview)
- [x] 導出圖片 (Export to image)
- [x] 主題切換 (Theme switching)

### 輔助功能

- [x] 自動完成 (Auto-completion)
- [ ] 程式碼片段 (Snippets)
- [ ] 快速插入模板 (Quick templates)
- [x] 格式化 (Formatting)

### 整合功能

- [x] 與 d2 CLI 工具整合
- [x] 錯誤提示與修正建議
- [ ] 文件查詢 (Documentation lookup)
- [ ] 其他：\***\*\_\_\_\*\***

## 4. 核心價值（選擇一個）

- [ ] 極致簡單快速 - 最小化配置，開箱即用
- [ ] 功能豐富完整 - 提供全面的 D2 編輯體驗
- [ ] 高度可擴展 - 提供 API 讓用戶自定義功能
- [x] 深度整合 - 與 D2 CLI 無縫整合

## 5. 技術選擇

### 實作語言

> [x] Lua (原生 neovim)
> [ ] VimScript
> [ ] 混合使用
> 原因：不要 vm script

### 預覽實現方式

> [x] 使用瀏覽器預覽
> [ ] 使用終端機內預覽 (如 kitty graphics protocol)
> [ ] 使用外部應用程式
> [ ] 其他：
> 原因： CLI 內建

### 依賴管理

> 需要哪些外部工具？（如 d2 binary, ImageMagick 等）
>
> - d2 tree-sister
> - browser
> - d2 CLI

## 6. 使用場景範例

描述一個典型的使用流程：

```
" 範例：
" 1. 開啟 .d2 檔案
" 2. 編輯圖表定義
" 3. 使用 :D2Preview 開啟預覽
" 4. 即時看到圖表更新
" 5. 使用 :D2Export 導出為 SVG
```

> [請描述你期望的工作流程]

## 7. 差異化特色

這個 plugin 與其他 D2 工具最大的不同是什麼？

> 目前沒有看到適用的 d2 neovim plugin, 只有一個 vim 版本的: https://github.com/terrastruct/d2-vim

## 8. 配置哲學

### Plugin 配置方式偏好

> [x] 零配置，合理的預設值
> [ ] 高度可配置，提供詳細選項
> [ ] 漸進式配置，基礎功能簡單，進階功能可選

## 9. 相容性考量

### 需要支援的環境

> [ ] Neovim 版本要求：**0.11+**
> [ ] 作業系統：[x] Linux [x] macOS [x] Windows [x] WSL
> [ ] 其他 plugin 相容性考量：

## 10. 開發優先順序

請排序（1 最重要，5 最不重要）：

> [1] 預覽功能完善
> [2] 匯出功能完善
> [3] 編輯體驗優化
> [4] 錯誤處理與提示
> [5] 文檔與範例

---

💡 提示：

- 使用 :w 存檔後，我會自動讀取並處理
- 不需要回答所有問題，重點問題即可
- 可以用 bullet points 簡單列出
- 考慮你實際使用 D2 時的痛點和需求

