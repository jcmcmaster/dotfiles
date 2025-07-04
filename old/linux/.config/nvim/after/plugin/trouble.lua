require('trouble').setup()

vim.keymap.set("n", "<leader>ld", "<cmd>Trouble diagnostics toggle<CR>")
vim.keymap.set("n", "<leader>le", "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<CR>")
vim.keymap.set("n", "<leader>ll", "<cmd>Trouble lsp toggle focus=false<CR>")
vim.keymap.set("n", "<leader>lq", "<cmd>Trouble quickfix toggle<CR>")
vim.keymap.set("n", "<leader>lw", "<cmd>Trouble symbols toggle focus=false<CR>")
