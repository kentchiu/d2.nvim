-- lua/d2/health.lua
-- 健康檢查模組

local M = {}

function M.check()
  vim.health.start("D2.nvim")
  
  -- 檢查 D2 CLI
  local d2_executable = vim.fn.executable("d2")
  if d2_executable == 1 then
    local handle = io.popen("d2 --version 2>&1")
    if handle then
      local version = handle:read("*a"):gsub("\n", "")
      handle:close()
      vim.health.ok("D2 CLI found: " .. version)
    else
      vim.health.ok("D2 CLI found")
    end
  else
    vim.health.error("D2 CLI not found", {
      "Install D2 from https://d2lang.com/tour/install",
      "Or use: curl -fsSL https://d2lang.com/install.sh | sh -s --"
    })
  end
  
  -- 檢查 nvim-treesitter
  local has_treesitter = pcall(require, "nvim-treesitter")
  if has_treesitter then
    vim.health.ok("nvim-treesitter is installed")
    
    -- 檢查 d2 parser
    local parsers = require("nvim-treesitter.parsers")
    if parsers.has_parser("d2") then
      vim.health.ok("D2 parser is installed")
    else
      vim.health.warn("D2 parser not installed", {
        "Plugin will auto-install on next .d2 file open",
        "Or manually run :TSInstall d2"
      })
    end
  else
    vim.health.warn("nvim-treesitter not found", {
      "Tree-sitter syntax highlighting will not work",
      "Install with your package manager"
    })
  end
  
  -- 檢查瀏覽器開啟工具
  local has_browser_opener = false
  local opener_name = nil
  
  if vim.fn.has("mac") == 1 and vim.fn.executable("open") == 1 then
    has_browser_opener = true
    opener_name = "open (macOS)"
  elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
    has_browser_opener = true
    opener_name = "xdg-open (Linux)"
  elseif vim.fn.has("win32") == 1 then
    has_browser_opener = true
    opener_name = "Windows default"
  end
  
  if has_browser_opener then
    vim.health.ok("Browser opener available: " .. opener_name)
  else
    vim.health.warn("No browser opener found", {
      "Preview may not auto-open browser",
      "You'll need to manually open the preview URL"
    })
  end
  
  -- 檢查 Plugin 狀態
  local plugin_ok, d2 = pcall(require, "d2")
  if plugin_ok then
    vim.health.ok("D2.nvim plugin loaded")
    
    -- 檢查預覽狀態
    local preview_ok, preview = pcall(require, "d2.preview")
    if preview_ok and preview.status then
      local status = preview.status()
      if status.is_running then
        vim.health.info("Preview server is running on port " .. tostring(status.port))
      else
        vim.health.info("Preview server is not running")
      end
    end
  else
    vim.health.error("D2.nvim plugin failed to load")
  end
end

return M