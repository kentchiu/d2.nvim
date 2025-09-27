-- lua/d2/treesitter.lua
local M = {}

function M.setup()
  -- 設定 filetype
  vim.filetype.add({
    extension = {
      d2 = "d2",
    },
  })

  -- 檢查 d2 parser 是否已安裝
  M.ensure_d2_installed()
end

function M.ensure_d2_installed()
  -- 檢查 nvim-treesitter 是否存在
  local ok, config = pcall(require, "nvim-treesitter.config")
  if not ok then
    vim.schedule(function()
      vim.notify("Please install nvim-treesitter and run :TSInstall d2", vim.log.levels.WARN)
    end)
    return
  end

  -- 檢查 d2 是否已安裝
  local installed = config.get_installed and config.get_installed() or {}
  if vim.tbl_contains(installed, "d2") then
    return
  end

  -- 自動安裝 d2 parser
  vim.schedule(function()
    vim.cmd("TSInstall d2")
    vim.notify("Installing D2 parser...", vim.log.levels.INFO)
  end)
end

return M
