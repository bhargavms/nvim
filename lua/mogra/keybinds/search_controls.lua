local map = vim.g.set_custom_binds

-- ╭──────────────────────────────────────────────────────────╮
-- │ Telescope: LSP features (better integrations)            │
-- ╰──────────────────────────────────────────────────────────╯

-- LSP pickers
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references (telescope)" })
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP definitions (telescope)" })
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP implementations (telescope)" })
map("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "LSP type definitions (telescope)" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols (telescope)" })
map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols (telescope)" })
map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics (telescope)" })
map("n", "<leader>lE", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics (telescope)" })
map("n", "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", { desc = "Code actions (telescope)" })
map("n", "<leader>lc", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Incoming calls (telescope)" })
map("n", "<leader>lC", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "Outgoing calls (telescope)" })

-- Telescope-specific features (not in fzf-lua)
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })

-- ╭──────────────────────────────────────────────────────────╮
-- │ Note: File/grep operations moved to fzf-lua              │
-- │ <leader>ff, fo, fb, fw, fz, fh, ma, cm, gt, fa          │
-- ╰──────────────────────────────────────────────────────────╯
