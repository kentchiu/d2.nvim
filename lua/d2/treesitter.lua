-- lua/d2/treesitter.lua
-- 自動安裝 d2 parser 模組

local M = {}

function M.setup()
  -- 設定 filetype
  vim.filetype.add({
    extension = {
      d2 = "d2"
    }
  })
  
  -- 確保 d2 parser 已安裝
  M.ensure_d2_installed()
end

function M.ensure_d2_installed()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then return end
  
  -- 檢查 d2 parser 是否已安裝
  if not parsers.has_parser("d2") then
    -- 非同步安裝 d2 parser (使用 TSInstall 命令)
    vim.schedule(function()
      vim.cmd("TSInstall d2")
      vim.notify("Installing D2 parser...", vim.log.levels.INFO)
    end)
  end
end

return M