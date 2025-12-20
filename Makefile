.PHONY: all install clean update update-neovim help

SCRIPTS_DIR := scripts

# Default target
all: help

# Install LuaRocks
install:
	@echo "Installing LuaRocks..."
	@./$(SCRIPTS_DIR)/install_luarocks.sh
	@echo "Installing golang..."
	@./$(SCRIPTS_DIR)/install_go.sh
	@echo "Installing npm..."
	@./${SCRIPTS_DIR}/install_npm.sh

update:
	@echo "Updating All Installations..."
	@./${SCRIPTS_DIR}/update.sh

# Update Neovim
update-neovim:
	@./update_neovim.sh

# Clean up temporary files
clean:
	@./$(SCRIPTS_DIR)/clean.sh

# Help message
help:
	@echo "LuaRocks Installer Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make install       - Install latest version of LuaRocks"
	@echo "  make clean         - Clean up temporary files"
	@echo "  make update        - Update installations"
	@echo "  make update-neovim - Update Neovim to latest version"
	@echo "  make help          - Show this help message"
