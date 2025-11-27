return {
  formatters_by_ft = {
    lua = { "stylua" },
    kotlin = { "ktlint", "ktfmt" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    cpp = { "clang-format" },
    yaml = { "yamlfix" },
    bash = { "beautysh" },
    json = { "prettierd", "prettier", stop_after_first = true },
    hcl = { "terraform_fmt" },
  },
}
