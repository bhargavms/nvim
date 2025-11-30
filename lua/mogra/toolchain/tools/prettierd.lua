local helpers = require("mogra.toolchain.helpers")

return {
  name = "prettierd",
  description = "Prettier daemon for faster formatting",
  install_cmd = "npm install -g @fsouza/prettierd",
  update_cmd = "npm install -g @fsouza/prettierd@latest",
  is_installed = function()
    return helpers.command_exists("prettierd")
  end,
}
