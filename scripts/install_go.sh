#!/bin/bash

set -e

TEMP_DIR="/tmp/go-install"
GO_VERSION="1.22.1"  # Latest stable as of March 2025
DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.darwin-amd64.tar.gz"
TARBALL="go${GO_VERSION}.darwin-amd64.tar.gz"
INSTALL_DIR="/usr/local"  # Standard location on macOS

# Create and move to temp directory
echo "Creating temporary directory..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Check if Go is already installed
if command -v go &> /dev/null; then
  CURRENT_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
  echo "Go is already installed (version $CURRENT_VERSION)"

  if [[ "$CURRENT_VERSION" == "$GO_VERSION" ]]; then
    echo "You already have the latest version. Exiting."
    exit 0
  else
    echo "Will upgrade from $CURRENT_VERSION to $GO_VERSION"
  fi
fi

# Download Go
echo "Downloading Go ${GO_VERSION}..."
if command -v curl &> /dev/null; then
  curl -L -O "$DOWNLOAD_URL"
elif command -v wget &> /dev/null; then
  wget "$DOWNLOAD_URL"
else
  echo "Error: Neither curl nor wget found. Please install one of them."
  exit 1
fi

# Extract tarball
echo "Extracting Go..."
if [[ -d "$INSTALL_DIR/go" ]]; then
  echo "Removing existing Go installation..."
  sudo rm -rf "$INSTALL_DIR/go"
fi

echo "Installing Go to $INSTALL_DIR..."
sudo tar -C "$INSTALL_DIR" -xzf "$TARBALL"

# Clean up
echo "Cleaning up..."
cd ~
rm -rf "$TEMP_DIR"

# Verify installation
if [[ -x "$INSTALL_DIR/go/bin/go" ]]; then
  echo "✅ Go installation successful!"
  echo "Version: $($INSTALL_DIR/go/bin/go version)"
else
  echo "❌ Go installation may have failed. Please check for errors."
  exit 1
fi

# Setup environment variables
echo ""
echo "Please add Go to your PATH by adding these lines to your ~/.zshrc or ~/.bash_profile:"
echo "export GOROOT=$INSTALL_DIR/go"
echo "export GOPATH=\$HOME/go"
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin"

echo ""
echo "You can do this by running:"
echo "echo 'export GOROOT=$INSTALL_DIR/go' >> ~/.zshrc"
echo "echo 'export GOPATH=\$HOME/go' >> ~/.zshrc"
echo "echo 'export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin' >> ~/.zshrc"
echo "source ~/.zshrc"
