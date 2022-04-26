local opts = { noremap = true, silent = true }

vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

vim.keymap.set("n", "gh", ":Rg<CR>", opts)
vim.keymap.set("n", "gf", ":FZF<CR>", opts)
vim.keymap.set("n", "gj", ":NvimTreeToggle<CR>", opts)

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

vim.cmd [[
    command Rc e ~/.config/nvim/init.lua
    command Src source ~/.config/nvim/init.lua
]]
