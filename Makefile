.PHONY: all install clean help

SCRIPTS_DIR := scripts

# Default target
all: help

# Install LuaRocks
install:
	@echo "Installing LuaRocks..."
	@./$(SCRIPTS_DIR)/install_luarocks.sh
	@echo "Installing golang..."
	@./$(SCRIPTS_DIR)/install_go.sh

# Clean up temporary files
clean:
	@./$(SCRIPTS_DIR)/clean.sh

# Help message
help:
	@echo "LuaRocks Installer Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make install  - Install latest version of LuaRocks"
	@echo "  make clean    - Clean up temporary files"
	@echo "  make help     - Show this help message"
