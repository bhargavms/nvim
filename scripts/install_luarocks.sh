#!/bin/bash

# Exit on error
set -e

# Define variables
TEMP_DIR="/tmp/luarocks-install"
LUAROCKS_VERSION="3.11.1"
DOWNLOAD_URL="https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
TARBALL="luarocks-${LUAROCKS_VERSION}.tar.gz"
LUA_VERSION="5.4.6"
LUA_DOWNLOAD_URL="https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz"
LUA_TARBALL="lua-${LUA_VERSION}.tar.gz"

# Check if Lua is installed
check_lua() {
  if command -v lua &> /dev/null; then
    echo "✅ Lua is already installed: $(lua -v)"
    return 0
  else
    echo "❌ Lua is not installed."
    return 1
  fi
}

# Install Lua
install_lua() {
  echo "Installing Lua ${LUA_VERSION}..."
  mkdir -p "$TEMP_DIR/lua"
  cd "$TEMP_DIR/lua"

  # Download Lua
  if command -v wget &> /dev/null; then
    wget "$LUA_DOWNLOAD_URL"
  elif command -v curl &> /dev/null; then
    curl -L -O "$LUA_DOWNLOAD_URL"
  else
    echo "Error: Neither wget nor curl found. Please install one of them."
    exit 1
  fi

  # Extract and build Lua
  tar zxf "$LUA_TARBALL"
  cd "lua-${LUA_VERSION}"

  # Build with proper flags for macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Building Lua for macOS..."
    make macosx
  else
    echo "Building Lua for generic Linux/Unix..."
    make linux
  fi

  # Install Lua
  sudo make install

  # Verify installation
  if check_lua; then
    echo "Lua installation successful."
  else
    echo "Lua installation failed."
    exit 1
  fi
}

# Create and move to temp directory
echo "Creating temporary directory..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Check and install Lua if needed
if ! check_lua; then
  install_lua
fi

# Download LuaRocks
echo "Downloading LuaRocks ${LUAROCKS_VERSION}..."
if command -v wget &> /dev/null; then
  wget "$DOWNLOAD_URL"
elif command -v curl &> /dev/null; then
  curl -L -O "$DOWNLOAD_URL"
else
  echo "Error: Neither wget nor curl found. Please install one of them."
  exit 1
fi

# Extract tarball
echo "Extracting tarball..."
tar zxf "$TARBALL"
cd "luarocks-${LUAROCKS_VERSION}"

# Configure and install
echo "Configuring LuaRocks..."
./configure

echo "Building LuaRocks..."
make

echo "Installing LuaRocks (requires sudo)..."
sudo make install

# Clean up
echo "Cleaning up..."
cd ~
rm -rf "$TEMP_DIR"

# Verify installation
if command -v luarocks &> /dev/null; then
  echo "✅ LuaRocks installation successful!"
  echo "Version: $(luarocks --version)"
else
  echo "❌ Installation may have failed. Please check for errors."
  exit 1
fi

echo ""
echo "You may need to add Lua and LuaRocks to your PATH if they're not already there."
echo "Add this to your ~/.zshrc or ~/.bash_profile:"
echo "export PATH=\$PATH:/usr/local/bin"
