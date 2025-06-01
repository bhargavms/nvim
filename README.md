# Mogra Neovim Configuration

A modern, modular, and maintainable Neovim configuration built with Lua. This configuration is designed to be fast, feature-rich, and easy to extend.

## 🌟 Features

- **Modular Structure**: Organized into logical modules for easy maintenance and extension
- **Lazy Loading**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for efficient plugin management
- **Modern UI**: Clean and intuitive interface with custom statusline and tabline
- **Development Tools**: Built-in support for various development tools and language servers
- **Custom Plugins**: Includes custom plugins like `mogra-tools` for managing development tools

## 📦 Prerequisites

- Neovim 0.9.0 or higher
- Git
- A Unix-like operating system (macOS, Linux)

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/bhargav/mogra-nvim ~/.config/nvim
   ```

2. Start Neovim:
   ```bash
   nvim
   ```

3. The first time you start Neovim, it will:
   - Bootstrap lazy.nvim
   - Install all required plugins
   - Set up development tools

## 🏗️ Project Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   └── mogra/              # Main configuration directory
│       ├── initialization/ # Core initialization modules
│       ├── plugins/        # Plugin configurations
│       ├── options/        # Neovim options
│       ├── keybinds/       # Key mappings
│       ├── configs/        # Plugin configurations
│       ├── ui/            # UI customizations
│       └── autocmds.lua   # Autocommands
├── scripts/                # Utility scripts
└── doc/                   # Documentation
```

## 🛠️ Custom Plugins

### Mogra Tools

A Mason-like interface for managing development tools. Features:
- Interactive UI for tool management
- Support for Go, NPM, and LuaRocks
- Easy installation and updates
- User-level installations (no sudo required)

Commands:
- `:MograTools` - Open the tools UI
- `:MograInstallAll` - Install all tools
- `:MograUpdateAll` - Update all tools

## 🔧 Development Tools

The configuration includes support for:
- Go development tools
- Node.js and npm
- Lua and LuaRocks
- Language servers (via Mason)

## ⌨️ Key Mappings

- `<leader>` is set to space
- See `lua/mogra/keybinds/` for detailed key mappings

## 🎨 UI Customizations

- Custom statusline
- Custom tabline
- Modern color scheme
- Improved window management

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Neovim](https://neovim.io/) - The editor
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Mason](https://github.com/williamboman/mason.nvim) - Inspiration for mogra-tools
- [NvChad](https://github.com/NvChad/NvChad) - Inspiration for UI and configuration structure
