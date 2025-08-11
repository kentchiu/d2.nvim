# Makefile for d2.nvim

.PHONY: test test-file test-story install-test-deps help

# 預設目標
help:
	@echo "d2.nvim Makefile"
	@echo "================"
	@echo ""
	@echo "Available targets:"
	@echo "  make test           - Run all tests"
	@echo "  make test-file F=<file> - Run specific test file"
	@echo "  make test-story S=001   - Run specific story tests"
	@echo "  make install-test-deps  - Install test dependencies"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  make test-file F=test_story_001_preview.lua"
	@echo "  make test-story S=001"

# 安裝測試相依套件
install-test-deps:
	@echo "Installing test dependencies..."
	@if [ ! -d "$$HOME/.local/share/nvim/lazy/plenary.nvim" ]; then \
		git clone https://github.com/nvim-lua/plenary.nvim \
			$$HOME/.local/share/nvim/lazy/plenary.nvim; \
	else \
		echo "plenary.nvim already installed"; \
	fi

# 執行所有測試
test:
	@echo "Running all tests..."
	@nvim --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { minimal_init = './tests/minimal_init.lua' }"

# 執行特定測試檔案
test-file:
	@if [ -z "$(F)" ]; then \
		echo "Error: Please specify test file with F=<filename>"; \
		echo "Example: make test-file F=test_story_001_preview.lua"; \
		exit 1; \
	fi
	@echo "Running test file: $(F)"
	@nvim --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedFile tests/$(F)"

# 執行特定 Story 的測試
test-story:
	@if [ -z "$(S)" ]; then \
		echo "Error: Please specify story number with S=<number>"; \
		echo "Example: make test-story S=001"; \
		exit 1; \
	fi
	@echo "Running tests for STORY-$(S)..."
	@nvim --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedFile tests/test_story_$(S)_*.lua"

# 執行 TDD Red 階段的第一個測試
test-red:
	@echo "Running TDD Red phase test for STORY-001..."
	@nvim --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedFile tests/test_story_001_preview.lua" \
		-c "qa!" 2>&1 | tee test-output.log
	@echo ""
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "🔴 測試應該失敗（RED）- 這是預期的行為！"
	@echo "下一步：實作程式碼讓測試通過（GREEN）"
	@echo "═══════════════════════════════════════════════════════════════"