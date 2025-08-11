# D2.nvim

Neovim plugin for D2 diagramming language.

## 安裝

### 前置需求

1. **D2 CLI**：
   ```bash
   # macOS
   brew install d2
   
   # Linux (使用安裝腳本)
   curl -fsSL https://d2lang.com/install.sh | sh -s --
   
   # 或從 GitHub releases 下載
   # https://github.com/terrastruct/d2/releases
   ```

2. **Neovim >= 0.9.0**

### 使用 lazy.nvim

```lua
{
  "kentchiu/d2.nvim",
  ft = "d2",
  config = function()
    require("d2").setup()
  end,
}
```

### 使用 packer.nvim

```lua
use {
  'kentchiu/d2.nvim',
  ft = {'d2'},
  config = function()
    require('d2').setup()
  end
}
```

## 使用方法

### 1. 建立 D2 檔案

建立一個 `.d2` 檔案：

```bash
nvim example.d2
```

### 2. 編寫 D2 圖表

```d2
# example.d2
users -> database: fetch data
database -> cache: store
cache -> users: return

users: {
  shape: person
  style.fill: lightblue
}

database: {
  shape: cylinder
  style.fill: lightgreen
}

cache: {
  shape: hexagon
  style.fill: lightyellow
}
```

### 3. 啟動預覽

在 Neovim 中執行：

```vim
:D2Preview
```

這會：
- 啟動 D2 watch 伺服器
- 自動選擇可用的埠號
- 在瀏覽器中開啟預覽（如果系統支援）

### 4. 即時更新

- 編輯並儲存 `.d2` 檔案
- 預覽會自動更新（D2 CLI 的 watch 模式內建功能）

### 5. 停止預覽

```vim
:D2PreviewStop
```

## 可用命令

| 命令 | 說明 |
|------|------|
| `:D2Preview` | 啟動即時預覽伺服器 |
| `:D2PreviewStop` | 停止預覽伺服器 |

## 測試範例

### 簡單流程圖

```d2
# flow.d2
start -> process -> decision
decision -> yes -> end
decision -> no -> process

start: {shape: oval}
end: {shape: oval}
decision: {shape: diamond}
```

### 系統架構圖

```d2
# architecture.d2
frontend -> api: HTTP/REST
api -> database: SQL
api -> cache: Redis Protocol
api -> queue: AMQP

frontend: React App {
  style.fill: "#61dafb"
}

api: Node.js Server {
  style.fill: "#68a063"
}

database: PostgreSQL {
  shape: cylinder
  style.fill: "#336791"
}

cache: Redis {
  shape: hexagon
  style.fill: "#d82c20"
}

queue: RabbitMQ {
  style.fill: "#ff6600"
}
```

## 疑難排解

### 1. 檢查 D2 是否安裝

```bash
d2 --version
```

### 2. 手動測試 D2 預覽

```bash
# 在終端機測試
d2 --watch test.d2
```

### 3. 檢查 Plugin 狀態

在 Neovim 中：

```lua
:lua print(vim.inspect(require("d2.preview").status()))
```

### 4. 常見問題

**Q: 預覽沒有自動開啟瀏覽器**
A: 某些系統可能不支援自動開啟，請手動開啟瀏覽器並訪問顯示的 URL（通常是 `http://localhost:xxxx`）

**Q: 錯誤訊息 "D2 CLI not found"**
A: 確認 D2 已安裝且在 PATH 中：
```bash
which d2
echo $PATH
```

**Q: 預覽沒有更新**
A: 確認檔案已儲存（`:w`），D2 watch 模式只在檔案實際寫入磁碟時觸發

## 開發狀態

目前已完成功能：
- ✅ 即時預覽（STORY-001）
  - D2 CLI 檢測
  - Watch 模式整合
  - 預覽控制命令

計劃中功能：
- ⬜ 導出功能（STORY-002）
- ⬜ Tree-sitter 語法高亮（STORY-003）
- ⬜ 程式碼格式化（STORY-005）

## 測試

```bash
# 執行所有測試
make test

# 執行特定 Story 測試
make test-story S=001
```

## License

MIT