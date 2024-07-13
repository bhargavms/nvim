local map = vim.g.set_custom_binds

map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader>e", "<cmd>Telescope buffers<CR>", { desc = "Telescope show open buffers" })
map("n", "<C-]>", "<cmd>bn<CR>", { desc = "Go to next buffer" })
map("n", "<C-[>", "<cmd>bp<CR>", { desc = "Go to previous buffer" })

-- map("n", "<tab>", function()
--  require("nvchad.tabufline").next()
-- end, { desc = "buffer goto next" })

-- map("n", "<S-tab>", function()
-- require("nvchad.tabufline").prev()
-- end, { desc = "buffer goto prev" })

--map("n", "<leader>x", function()
 -- require("nvchad.tabufline").close_buffer()
-- end, { desc = "buffer close" })
