local helpers = require("mogra.toolchain.helpers")

return {
  name = "Go",
  description = "Go programming language",
  get_install_cmd = function()
    local arch = vim.fn.system("uname -m"):gsub("%s+", "")
    local go_version = "1.22.1"
    local platform = "darwin"

    if arch == "arm64" or arch == "aarch64" then
      arch = "arm64"
    else
      arch = "amd64"
    end

    local archive = "go" .. go_version .. "." .. platform .. "-" .. arch .. ".tar.gz"
    local url = "https://go.dev/dl/" .. archive
    local install_dir = vim.fn.expand("~/.local/go")

    return string.format(
      [[mkdir -p %s && curl -L %s -o /tmp/%s && rm -rf %s/go && tar -C %s -xzf /tmp/%s && rm /tmp/%s && echo 'Add to .zshrc: export PATH=$PATH:%s/go/bin:$HOME/go/bin']],
      install_dir,
      url,
      archive,
      install_dir,
      install_dir,
      archive,
      archive,
      install_dir
    )
  end,
  get_update_cmd = function()
    return "echo 'To update Go, reinstall with the latest version'"
  end,
  is_installed = function()
    return helpers.command_exists("go")
  end,
}
