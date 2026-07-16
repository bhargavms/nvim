local web = require "mogra.tooling.web"

local function first_available(...)
  local formatters = { ... }
  formatters.stop_after_first = true
  return formatters
end

local function workspace_formatters(bufnr, fallback)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local formatter = web.workspace(path).formatter

  if formatter == "oxfmt" then
    return first_available "oxfmt"
  elseif formatter == "prettier" then
    return first_available("prettier", "prettierd")
  end

  return fallback
end

local function web_formatters(bufnr)
  return workspace_formatters(bufnr, first_available("oxfmt", "prettierd", "prettier"))
end

local function project_formatter(name)
  local function command(ctx)
    local workspace = web.workspace(ctx.filename)
    local local_executable = workspace.root and vim.fs.joinpath(workspace.root, "node_modules", ".bin", name) or name
    if vim.uv.fs_stat(local_executable) == nil then
      local_executable = name
    end
    return web.node_command(ctx.filename, local_executable)
  end

  return {
    command = function(_, ctx)
      return command(ctx)[1]
    end,
    prepend_args = function(_, ctx)
      return vim.list_slice(command(ctx), 2)
    end,
  }
end

return {
  default_format_opts = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return nil
    end
    if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
      return nil
    end
    -- FINN intentionally excludes Angular templates in .oxfmtrc.json.
    if vim.bo[bufnr].filetype == "htmlangular" then
      return nil
    end

    return {
      timeout_ms = 1000,
      lsp_format = "fallback",
    }
  end,

  formatters_by_ft = {
    lua = { "stylua" },
    kotlin = { "ktlint", "ktfmt" },
    markdown = function(bufnr)
      return workspace_formatters(bufnr, first_available("prettierd", "prettier"))
    end,
    cpp = { "clang-format" },
    yaml = function(bufnr)
      return workspace_formatters(bufnr, { "yamlfix" })
    end,
    bash = { "beautysh" },
    json = web_formatters,
    jsonc = web_formatters,
    hcl = { "terraform_fmt" },
    javascript = web_formatters,
    javascriptreact = web_formatters,
    typescript = web_formatters,
    typescriptreact = web_formatters,
    css = web_formatters,
    scss = web_formatters,
    html = web_formatters,
    graphql = web_formatters,
  },

  formatters = {
    oxfmt = project_formatter "oxfmt",
    prettier = project_formatter "prettier",
  },
}
