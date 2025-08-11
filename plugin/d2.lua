-- plugin/d2.lua
-- D2.nvim plugin 入口點

-- 只在 .d2 檔案載入
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.d2",
  callback = function()
    vim.bo.filetype = "d2"
  end,
})

-- 當 filetype 設為 d2 時載入 plugin
vim.api.nvim_create_autocmd("FileType", {
  pattern = "d2",
  callback = function()
    require("d2").setup()
  end,
})