
local map = vim.g.set_custom_binds
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
-- Resize vertical splits with Ctrl+Up and Ctrl+Down
map('n', '<M-Up>', ':resize +5<CR>', { noremap = true, silent = true, desc = 'Increase window height' })
map('n', '<M-Down>', ':resize -5<CR>', { noremap = true, silent = true, desc = 'Decrease window height' })

-- For horizontal resizing (complementary to your Ctrl+> approach)
map('n', '<M-Right>', ':vertical resize +5<CR>', { noremap = true, silent = true, desc = 'Increase window width' })
map('n', '<M-Left>', ':vertical resize -5<CR>', { noremap = true, silent = true, desc = 'Decrease window width' })
