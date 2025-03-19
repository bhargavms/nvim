local map = vim.keymap.set

-- Keybinding to find files in the current nvim-tree directory
map(
  "n",
  "<leader>nff",
  "<cmd>lua require('telescope.builtin').find_files({ " ..
  "cwd = require('nvim-tree.lib').get_node_at_cursor().absolute_path })<CR>",
  { noremap = true, silent = true }
)

-- Keybinding to live grep in the current nvim-tree directory
map(
  "n",
  "<leader>nfw",
  "<cmd>lua require('telescope.builtin').live_grep({ " ..
  "cwd = require('nvim-tree.lib').get_node_at_cursor().absolute_path })<CR>",
  { noremap = true, silent = true }
)

map("n", "<C-.>", ":NvimTreeResize +5<CR>", { noremap = true, silent = true })
map("n", "<C-,>", ":NvimTreeResize -5<CR>", { noremap = true, silent = true })
