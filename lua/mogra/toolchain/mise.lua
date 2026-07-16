local helpers = require "mogra.toolchain.helpers"

return {
  name = "mise",
  description = "Project-aware runtime and tool version manager",
  is_installed = function()
    return helpers.command_exists "mise"
  end,
  get_install_cmd = function()
    if vim.fn.executable "brew" ~= 1 then
      return nil, "Homebrew is not installed"
    end
    return "brew install mise"
  end,
  update_cmd = "brew upgrade mise",
}
