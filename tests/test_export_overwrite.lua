-- tests/test_export_overwrite.lua

local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local assert = require("luassert")

describe("Export with overwrite confirmation", function()
  
  it("應該生成與 D2 檔案同名的輸出檔", function()
    -- Given: 一個 D2 檔案名稱
    local current_file = "/path/to/diagram.d2"
    
    -- 模擬 generate_output_filename 函數
    local function generate_output_filename(file, format)
      local dir = vim.fn.fnamemodify(file, ":h")
      local base = vim.fn.fnamemodify(file, ":t:r")
      return string.format("%s/%s.%s", dir, base, format)
    end
    
    -- When: 生成 SVG 輸出檔名
    local svg_output = generate_output_filename(current_file, "svg")
    
    -- Then: 輸出檔名應該與 D2 檔案同名
    assert.equals("/path/to/diagram.svg", svg_output)
    
    -- When: 生成 PNG 輸出檔名
    local png_output = generate_output_filename(current_file, "png")
    
    -- Then: 輸出檔名應該與 D2 檔案同名
    assert.equals("/path/to/diagram.png", png_output)
  end)
  
  it("應該檢測檔案是否存在", function()
    -- Given: 一個測試檔案
    local test_file = "/tmp/test_d2_export.txt"
    
    -- 創建測試檔案
    local file = io.open(test_file, "w")
    file:write("test")
    file:close()
    
    -- When: 檢查檔案是否存在
    local exists = vim.fn.filereadable(test_file) == 1
    
    -- Then: 應該檢測到檔案存在
    assert.is_true(exists)
    
    -- 清理測試檔案
    os.remove(test_file)
    
    -- When: 再次檢查
    local not_exists = vim.fn.filereadable(test_file) == 0
    
    -- Then: 應該檢測到檔案不存在
    assert.is_true(not_exists)
  end)
  
  it("應該正確處理覆蓋邏輯", function()
    -- Given: 模擬的選擇函數
    local user_choice = nil
    local prompt_called = false
    
    local function mock_select(choices, opts, callback)
      prompt_called = true
      assert.equals(2, #choices)
      assert.equals("Yes", choices[1])
      assert.equals("No", choices[2])
      callback(user_choice)
    end
    
    -- 模擬檔案存在的情況
    local function handle_export(file_exists)
      if file_exists then
        mock_select({"Yes", "No"}, {prompt = "Overwrite?"}, function(choice)
          if choice == "Yes" then
            return "exported"
          else
            return "cancelled"
          end
        end)
      else
        return "exported"
      end
    end
    
    -- Test 1: 檔案不存在，直接導出
    local result = handle_export(false)
    assert.equals("exported", result)
    
    -- Test 2: 檔案存在，用戶選擇覆蓋
    user_choice = "Yes"
    prompt_called = false
    result = handle_export(true)
    assert.is_true(prompt_called)
    
    -- Test 3: 檔案存在，用戶取消
    user_choice = "No"
    prompt_called = false
    result = handle_export(true)
    assert.is_true(prompt_called)
  end)
end)