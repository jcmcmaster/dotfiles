local opts = { noremap = true, silent = true }

vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

vim.keymap.set("n", "gb", ":Telescope buffers<CR>", opts)
vim.keymap.set("n", "gf", ":Telescope live_grep<CR>", opts)
vim.keymap.set("n", "gh", ":Telescope<CR>", opts)
vim.keymap.set("n", "gj", ":NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "go", ":Telescope find_files<CR>", opts)
vim.keymap.set("n", "gr", ":Telescope registers<CR>", opts)
vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", opts)
vim.keymap.set("n", "<leader>T", ":TestFile<CR>", opts)
vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", opts)
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", opts)
vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>", opts)

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv", opts)

vim.keymap.set("v", "p", '"_dP', opts)

vim.api.nvim_create_user_command("Rc", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Src", "source ~/.config/nvim/init.lua", {})
