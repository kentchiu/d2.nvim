-- tests/minimal_init.lua
-- 測試環境的最小初始化設定

-- 設定 runtimepath
vim.opt.rtp:append(".")
vim.opt.rtp:append("~/.local/share/nvim/lazy/plenary.nvim")

-- 載入 plenary（測試框架）
vim.cmd("runtime plugin/plenary.vim")

-- 設定 package path 以載入專案模組
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"