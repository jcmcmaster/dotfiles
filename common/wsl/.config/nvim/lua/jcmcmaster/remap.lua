vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<C-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-Down>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-Up>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-Right>", ":wincmd l<CR>")

vim.keymap.set("n", "<A-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<A-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<A-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>")

vim.keymap.set("n", "<S-h>", ":bprevious<CR>")
vim.keymap.set("n", "<S-l>", ":bnext<CR>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_user_command("Rc", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Src", "source ~/.config/nvim/init.lua", {})
