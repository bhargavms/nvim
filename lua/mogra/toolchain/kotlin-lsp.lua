return {
  name = "Kotlin LSP",
  description = "Kotlin Language Server from JetBrains (via Homebrew)",
  get_install_cmd = function()
    return "brew install JetBrains/utils/kotlin-lsp"
  end,
  get_update_cmd = function()
    return "brew upgrade JetBrains/utils/kotlin-lsp"
  end,
  is_installed = function()
    return vim.fn.executable("kotlin-lsp") == 1
  end,
}
