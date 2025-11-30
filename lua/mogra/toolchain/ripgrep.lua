local helpers = require("mogra.toolchain.helpers")

return {
  name = "Ripgrep",
  description = "Fast line-oriented search tool",
  get_install_cmd = function()
    local version, download_url = helpers.get_latest_github_release("BurntSushi/ripgrep")
    if not version or not download_url then
      return nil, "Failed to get download URL for Ripgrep"
    end

    local arch, os_name = helpers.detect_system()
    arch, os_name = helpers.validate_system_combination(arch, os_name)

    local temp_dir = vim.fn.expand("~/.local/tmp/ripgrep-install")
    local install_dir = vim.fn.expand("~/.local/bin")
    local archive_name = "ripgrep-" .. version .. "-" .. arch .. "-" .. os_name

    return string.format([[
      mkdir -p %s %s && \
      cd %s && curl -LO %s && \
      tar xzf %s.tar.gz && \
      cp %s/rg %s/rg && \
      chmod +x %s/rg && \
      rm -rf %s
    ]],
      temp_dir, install_dir,
      temp_dir, download_url,
      archive_name,
      archive_name, install_dir,
      install_dir,
      temp_dir
    )
  end,
  get_update_cmd = function()
    local version, download_url = helpers.get_latest_github_release("BurntSushi/ripgrep")
    if not version or not download_url then
      return nil, "Failed to get download URL for Ripgrep"
    end

    local arch, os_name = helpers.detect_system()
    arch, os_name = helpers.validate_system_combination(arch, os_name)

    local temp_dir = vim.fn.expand("~/.local/tmp/ripgrep-update")
    local install_dir = vim.fn.expand("~/.local/bin")
    local archive_name = "ripgrep-" .. version .. "-" .. arch .. "-" .. os_name

    return string.format([[
      mkdir -p %s && \
      cd %s && curl -LO %s && \
      tar xzf %s.tar.gz && \
      cp %s/rg %s/rg && \
      chmod +x %s/rg && \
      rm -rf %s
    ]],
      temp_dir,
      temp_dir, download_url,
      archive_name,
      archive_name, install_dir,
      install_dir,
      temp_dir
    )
  end,
  is_installed = function()
    return helpers.command_exists("rg")
  end,
}
