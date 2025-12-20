#!/bin/bash

# Neovim Update Script
# Updates Neovim from official GitHub releases

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
NVIM_INSTALL_DIR="/Applications/nvim-macos-arm64"
NVIM_SYMLINK="/usr/local/bin/nvim"
GITHUB_API="https://api.github.com/repos/neovim/neovim/releases/latest"
TEMP_DIR=$(mktemp -d)
ARCH="arm64"
BACKUP_DIR=""

# Cleanup function
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# Error handling
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Print colored messages
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error_exit "This script is designed for macOS only"
fi

# Check architecture
if [[ "$(uname -m)" != "arm64" ]]; then
    error_exit "This script is designed for ARM64 architecture only"
fi

info "Starting Neovim update process..."

# Check current version
if [ -L "$NVIM_SYMLINK" ] && [ -x "$NVIM_SYMLINK" ]; then
    CURRENT_VERSION=$("$NVIM_SYMLINK" --version | head -1 | awk '{print $2}')
    info "Current Neovim version: $CURRENT_VERSION"
else
    warn "Neovim symlink not found or broken, proceeding with fresh install"
    CURRENT_VERSION="unknown"
fi

# Fetch latest version from GitHub API
info "Fetching latest Neovim version from GitHub..."
API_RESPONSE=$(curl -s "$GITHUB_API")

if command -v jq &> /dev/null; then
    LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.tag_name | ltrimstr("v")')
else
    warn "jq not found, using fallback JSON parsing"
    LATEST_VERSION=$(echo "$API_RESPONSE" | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": "v?([^"]+)".*/\1/')
fi

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
    error_exit "Failed to fetch latest version from GitHub"
fi

info "Latest Neovim version: v$LATEST_VERSION"

# Check if update is needed
if [ "$CURRENT_VERSION" = "v$LATEST_VERSION" ]; then
    info "Neovim is already up to date (v$LATEST_VERSION)"
    exit 0
fi

# Download URL
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v${LATEST_VERSION}/nvim-macos-arm64.tar.gz"
ARCHIVE_NAME="nvim-macos-arm64.tar.gz"
ARCHIVE_PATH="$TEMP_DIR/$ARCHIVE_NAME"

info "Downloading Neovim v$LATEST_VERSION..."
if ! curl -L -o "$ARCHIVE_PATH" "$DOWNLOAD_URL"; then
    error_exit "Failed to download Neovim release"
fi

# Verify download
if [ ! -f "$ARCHIVE_PATH" ]; then
    error_exit "Downloaded file not found"
fi

info "Download complete"

# Verify checksum
info "Verifying checksum..."
SHA_URL="${DOWNLOAD_URL}.sha256sum"
SHA_PATH="$TEMP_DIR/$ARCHIVE_NAME.sha256sum"

if curl -sfL -o "$SHA_PATH" "$SHA_URL" && [ -s "$SHA_PATH" ]; then
    cd "$TEMP_DIR"
    EXPECTED_SHA=$(cat "$SHA_PATH" | awk '{print $1}')
    ACTUAL_SHA=$(shasum -a 256 "$ARCHIVE_NAME" | awk '{print $1}')
    if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
        error_exit "Checksum verification failed - expected $EXPECTED_SHA, got $ACTUAL_SHA"
    fi
    info "Checksum verified"
else
    warn "Could not verify checksum (sha256sum file not available)"
fi

# Backup current installation if it exists
if [ -d "$NVIM_INSTALL_DIR" ]; then
    BACKUP_DIR="${NVIM_INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    info "Backing up current installation to $BACKUP_DIR..."
    if ! cp -R "$NVIM_INSTALL_DIR" "$BACKUP_DIR"; then
        error_exit "Failed to backup current installation"
    fi
    info "Backup created successfully"
fi

# Extract archive
info "Extracting Neovim..."
cd "$TEMP_DIR"
if ! tar -xzf "$ARCHIVE_NAME"; then
    error_exit "Failed to extract archive"
fi

# Check if extracted directory exists
EXTRACTED_DIR="$TEMP_DIR/nvim-macos-arm64"
if [ ! -d "$EXTRACTED_DIR" ]; then
    error_exit "Extracted directory not found"
fi

# Remove old installation
if [ -d "$NVIM_INSTALL_DIR" ]; then
    info "Removing old installation..."
    if ! rm -rf "$NVIM_INSTALL_DIR"; then
        error_exit "Failed to remove old installation"
    fi
fi

# Install new version
info "Installing Neovim v$LATEST_VERSION..."
if ! mv "$EXTRACTED_DIR" "$NVIM_INSTALL_DIR"; then
    error_exit "Failed to install new version"
fi

# Verify symlink
if [ ! -L "$NVIM_SYMLINK" ]; then
    warn "Symlink not found, creating it..."
    if ! sudo ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$NVIM_SYMLINK"; then
        error_exit "Failed to create symlink (sudo required)"
    fi
else
    # Verify symlink points to correct location
    SYMLINK_TARGET=$(readlink "$NVIM_SYMLINK")
    if [ "$SYMLINK_TARGET" != "$NVIM_INSTALL_DIR/bin/nvim" ]; then
        warn "Symlink points to wrong location, updating..."
        if ! sudo ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$NVIM_SYMLINK"; then
            error_exit "Failed to update symlink (sudo required)"
        fi
    fi
fi

# Verify installation
info "Verifying installation..."
NEW_VERSION=$("$NVIM_SYMLINK" --version | head -1 | awk '{print $2}')
if [ "$NEW_VERSION" != "v$LATEST_VERSION" ]; then
    error_exit "Version mismatch: expected v$LATEST_VERSION, got $NEW_VERSION"
fi

info "Neovim successfully updated to v$LATEST_VERSION"
info "Installation location: $NVIM_INSTALL_DIR"
info "Symlink: $NVIM_SYMLINK"

if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
    info "Backup saved at: $BACKUP_DIR"
    info "You can remove it if the update is successful"
fi

# Cleanup old backups (keep only the 3 most recent)
BACKUP_COUNT=$(find /Applications -maxdepth 1 -type d -name "nvim-macos-arm64.backup.*" 2>/dev/null | wc -l | tr -d ' ')
if [ "$BACKUP_COUNT" -gt 3 ]; then
    info "Cleaning up old backups (keeping 3 most recent)..."
    find /Applications -maxdepth 1 -type d -name "nvim-macos-arm64.backup.*" -print0 2>/dev/null | \
        xargs -0 ls -dt | tail -n +4 | xargs rm -rf
fi

echo -e "${GREEN}Update complete!${NC}"
