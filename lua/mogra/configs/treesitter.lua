local M = {}

---@param opts table?
function M.setup(opts)
  opts = opts or {}

  local ts = require "nvim-treesitter"

  -- nvim-treesitter (main rewrite): small config surface (install_dir, etc.)
  ts.setup({
    install_dir = opts.install_dir or (vim.fn.stdpath "data" .. "/site"),
  })

  -- Ensure parsers are installed (async).
  if opts.ensure_installed and #opts.ensure_installed > 0 then
    ts.install(opts.ensure_installed)
  end

  -- Treesitter highlighting via Neovim's built-in API.
  if opts.highlight and opts.highlight.enable then
    local group = vim.api.nvim_create_augroup("MograTreesitterHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        -- Do not hard-fail if no parser exists for this buffer.
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end

  -- Treesitter-based indentation (experimental).
  if opts.indent and opts.indent.enable then
    local group = vim.api.nvim_create_augroup("MograTreesitterIndent", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
end

return M
