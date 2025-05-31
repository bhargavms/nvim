#!/bin/bash

# Exit on error
set -e

echo "🔧 Starting Neovim configuration update..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"

# Update language servers and tools
echo "🔄 Updating language servers and tools..."

# Update Go tools
if command -v go &> /dev/null; then
    echo "📦 Updating Go tools..."
    go install -v golang.org/x/tools/gopls@latest
    go install -v github.com/go-delve/delve/cmd/dlv@latest
fi

# Update NPM
if command -v npm &> /dev/null; then
    echo "📦 Updating NPM itself..."
    npm install -g npm@latest
fi

# Update LuaRocks packages
if command -v luarocks &> /dev/null; then
    echo "📦 Updating LuaRocks packages..."
    luarocks install --local --server=https://luarocks.org/dev lua-language-server
fi

# Clean temporary files
echo "🧹 Cleaning temporary files..."
"$SCRIPT_DIR/clean.sh"

echo "✅ Update completed successfully!"
