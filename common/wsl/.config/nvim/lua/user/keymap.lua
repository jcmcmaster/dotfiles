local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

keymap("n", "gf", ":Rg<CR>", opts)
keymap("n", "gh", ":FZF<CR>", opts)
keymap("n", "gj", ":NvimTreeToggle<CR>", opts)

keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("v", "<A-j>", ":m '>+1<CR>gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv", opts)

keymap("v", "p", '"_dP', opts)

vim.cmd [[
    command Rc e ~/.config/nvim/init.lua
    command Src source ~/.config/nvim/init.lua
]]
