return {
  formatters_by_ft = {
    lua = { "stylua" },
    kotlin = { "ktlint", "ktfmt" },
    markdown = { { "prettierd", "prettier" } },
    cpp = { "clang-format" },
    yaml = { "yamlfix" },
    bash = { "beautysh" },
    json = { { "prettierd", "prettier" } },
    hcl = { "terraform_fmt" },
  },
}
