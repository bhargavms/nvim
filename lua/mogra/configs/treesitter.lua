local M = {}

---@param opts table?
function M.setup(opts)
  opts = opts or {}

  if opts.install_dir and not opts.parser_install_dir then
    opts.parser_install_dir = opts.install_dir
    opts.install_dir = nil
  end

  local ok_install, install = pcall(require, "nvim-treesitter.install")
  if ok_install and vim.fn.executable "tree-sitter" == 1 then
    local major, minor = vim.fn.system({ "tree-sitter", "--version" }):match "(%d+)%.(%d+)%.%d+"
    if major and minor and (tonumber(major) > 0 or tonumber(minor) >= 26) then
      install.ts_generate_args = { "generate", "--abi", tostring(vim.treesitter.language_version) }
    end
  end

  require("nvim-treesitter.configs").setup(opts)
end

return M
