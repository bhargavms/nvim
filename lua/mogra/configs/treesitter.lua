local M = {}

---@param opts table?
function M.setup(opts)
  opts = opts or {}

  local treesitter = require "nvim-treesitter"
  local install_dir = opts.install_dir or opts.parser_install_dir

  treesitter.setup({
    install_dir = install_dir,
  })

  local languages = opts.ensure_installed or {}
  local installed = {}
  for _, language in ipairs(treesitter.get_installed()) do
    installed[language] = true
  end

  local missing = vim.tbl_filter(function(language)
    return not installed[language]
  end, languages)
  if #missing > 0 then
    treesitter.install(missing)
  end

  local configured_languages = {}
  for _, language in ipairs(languages) do
    configured_languages[language] = true
  end

  local group = vim.api.nvim_create_augroup("mogra_treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local language = vim.treesitter.language.get_lang(args.match) or args.match
      if not configured_languages[language] then
        return
      end

      local started = true
      if opts.highlight and opts.highlight.enable then
        started = pcall(vim.treesitter.start, args.buf, language)
      end

      if started and opts.indent and opts.indent.enable then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
