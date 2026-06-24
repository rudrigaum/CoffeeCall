# ==========================================
# 🛠  CoffeeCall - Useful Commands
# ==========================================

.PHONY: help clean open

# Variables
PROJECT_NAME = CoffeeCall

help:
	@echo "=========================================="
	@echo "        Available commands:"
	@echo "=========================================="
	@echo "  make clean      - Clears DerivedData (Fixes Xcode cache bugs)"
	@echo "  make open       - Opens the project in Xcode"
	@echo "=========================================="

clean:
	@echo "🧹 Clearing DerivedData..."
	@rm -rf ~/Library/Developer/Xcode/DerivedData/$(PROJECT_NAME)-*
	@echo "✨ Cache cleared successfully!"

open:
	@echo "🚀 Opening $(PROJECT_NAME)..."
	@open $(PROJECT_NAME).xcodeproj
