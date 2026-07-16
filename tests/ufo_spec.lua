local ufo_options
package.loaded.ufo = {
  openAllFolds = function() end,
  closeAllFolds = function() end,
  openFoldsExceptKinds = function() end,
  closeFoldsWith = function() end,
  peekFoldedLinesUnderCursor = function() end,
  setup = function(options)
    ufo_options = options
  end,
}
require("mogra.configs.ufo")()

local original_query_files = vim.treesitter.query.get_files
local original_language_add = vim.treesitter.language.add
vim.treesitter.query.get_files = function()
  return { "folds.scm" }
end
vim.treesitter.language.add = function()
  return nil, "parser unavailable"
end
local providers = ufo_options.provider_selector(0, "missing_parser", "")
vim.treesitter.query.get_files = original_query_files
vim.treesitter.language.add = original_language_add

assert(providers[2] == "indent", "UFO should not select Tree-sitter when the parser cannot be loaded")
print "PASS: UFO Tree-sitter fallback"
