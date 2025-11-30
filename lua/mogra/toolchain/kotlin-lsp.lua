local helpers = require("mogra.toolchain.helpers")

return {
  name = "Kotlin LSP",
  description = "Kotlin Language Server (kotlin-lsp)",
  get_install_cmd = function()
    local _, download_url = helpers.get_latest_github_release("Kotlin/kotlin-lsp")
    if not download_url then
      return nil, "Failed to get download URL for Kotlin LSP"
    end

    local install_dir = vim.fn.expand("~/.local/kotlin-lsp")
    local bin_dir = vim.fn.expand("~/.local/bin")

    return string.format([[
      rm -rf %s && \
      mkdir -p %s %s && \
      curl -L %s -o %s/server.zip && \
      unzip -o %s/server.zip -d %s && \
      rm %s/server.zip && \
      chmod +x %s/scripts/kotlin-lsp.sh && \
      ln -sf %s/scripts/kotlin-lsp.sh %s/kotlin-ls
    ]],
      install_dir,
      install_dir, bin_dir,
      download_url, install_dir,
      install_dir, install_dir,
      install_dir,
      install_dir,
      install_dir, bin_dir
    )
  end,
  get_update_cmd = function()
    local _, download_url = helpers.get_latest_github_release("Kotlin/kotlin-lsp")
    if not download_url then
      return nil, "Failed to get download URL for Kotlin LSP"
    end

    local install_dir = vim.fn.expand("~/.local/kotlin-lsp")
    local bin_dir = vim.fn.expand("~/.local/bin")

    return string.format([[
      rm -rf %s && \
      mkdir -p %s %s && \
      curl -L %s -o %s/server.zip && \
      unzip -o %s/server.zip -d %s && \
      rm %s/server.zip && \
      chmod +x %s/scripts/kotlin-lsp.sh && \
      ln -sf %s/scripts/kotlin-lsp.sh %s/kotlin-ls
    ]],
      install_dir,
      install_dir, bin_dir,
      download_url, install_dir,
      install_dir, install_dir,
      install_dir,
      install_dir,
      install_dir, bin_dir
    )
  end,
  is_installed = function()
    return vim.fn.executable("kotlin-ls") == 1
  end,
}
