#!/bin/bash

# install.sh - Install latest Node.js and npm using nvm
# Usage: chmod +x install.sh && ./install.sh

set -e  # Exit on any error

echo "🚀 Installing Node.js and npm via nvm..."

# Check if nvm is already installed
if command -v nvm &> /dev/null || [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "✅ nvm is already installed"
    # Source nvm to make it available in current session
    [ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
else
    echo "📥 Installing nvm..."

    # Get latest nvm version from GitHub API
    echo "🔍 Fetching latest nvm version..."
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')

    if [ -z "$NVM_VERSION" ]; then
        echo "⚠️  Could not fetch latest version, using fallback v0.40.3"
        NVM_VERSION="v0.40.3"
    else
        echo "✅ Latest nvm version: $NVM_VERSION"
    fi

    # Download and install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

    # Source nvm to make it available in current session
    \. "$HOME/.nvm/nvm.sh"

    echo "✅ nvm installed successfully"
fi

# Install latest LTS Node.js (which includes npm)
echo "📦 Installing latest Node.js LTS..."
nvm install --lts
nvm use --lts

# Update npm to latest version
echo "🔄 Updating npm to latest version..."
npm install -g npm@latest

# Verify installation
echo ""
echo "✅ Installation complete!"
echo "📋 Versions:"
echo "   Node.js: $(node -v)"
echo "   npm: $(npm -v)"
echo "   nvm current: $(nvm current)"

echo ""
echo "🎉 Node.js and npm are now ready to use!"
echo "💡 Tip: Run 'nvm use --lts' to switch to LTS version in new terminal sessions"
