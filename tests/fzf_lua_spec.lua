local options = require "mogra.options.fzf-lua"

assert(options.grep.query_delay == 200, "live grep should debounce repository searches")
assert(options.grep.rg_opts == nil, "live grep should retain fzf-lua's guarded ripgrep defaults")

local original_fzf = package.loaded["fzf-lua"]
local original_keymap_set = vim.keymap.set
local original_bufname = vim.api.nvim_buf_get_name(0)
local mapped = {}
local live_grep_options
local setup_options

package.loaded["fzf-lua"] = setmetatable({
  setup = function(opts)
    setup_options = opts
  end,
  live_grep = function(opts)
    live_grep_options = opts
  end,
}, {
  __index = function()
    return function() end
  end,
})

vim.keymap.set = function(mode, lhs, rhs)
  if mode == "n" then
    mapped[lhs] = rhs
  end
end

local root = vim.fn.tempname()
local nested = vim.fs.joinpath(root, "src")
local filename = vim.fs.joinpath(nested, "main.lua")

local ok, err = xpcall(function()
  vim.fn.mkdir(vim.fs.joinpath(root, ".git"), "p")
  vim.fn.mkdir(nested, "p")
  vim.fn.writefile({ "return true" }, filename)
  vim.api.nvim_buf_set_name(0, filename)

  require("mogra.configs.fzf-lua")(nil, options)

  assert(setup_options == options, "fzf-lua should receive the configured options")
  assert(type(mapped["<leader>fw"]) == "function", "live grep should resolve its search root at invocation time")

  mapped["<leader>fw"]()
  assert(
    vim.uv.fs_realpath(live_grep_options.cwd) == vim.uv.fs_realpath(root),
    "live grep should search the current buffer's Git repository"
  )
end, debug.traceback)

vim.keymap.set = original_keymap_set
package.loaded["fzf-lua"] = original_fzf
vim.api.nvim_buf_set_name(0, original_bufname)
vim.fn.delete(root, "rf")

assert(ok, err)
print "PASS: fzf-lua live grep safeguards"
