#!/usr/bin/env bash

# Exit on error
set -e

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

# Install dependencies if not already installed
if ! command -v busted &> /dev/null; then
    luarocks install busted
fi

# Run the tests
busted --lua=nvim \
    --lpath="$PLUGIN_DIR/?.lua" \
    --pattern=".*_spec.lua" \
    "$PLUGIN_DIR/tests"
