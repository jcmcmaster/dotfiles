vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>p", [["+p]])

vim.keymap.set("n", "<leader>t", ":terminal<CR>A")

vim.keymap.set("n", "<C-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-Down>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-Up>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-Right>", ":wincmd l<CR>")

vim.keymap.set("n", "<A-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<A-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<A-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>")

vim.keymap.set("n", "<S-Down>", ":split<CR>")
vim.keymap.set("n", "<S-Right>", ":vsplit<CR>")

vim.keymap.set("n", "<C-h>", ":bprevious<CR>")
vim.keymap.set("n", "<C-l>", ":bnext<CR>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_user_command("Rc", "e E:/Projects/dotfiles/linux/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Src", "source E:/Projects/dotfiles/linux/.config/nvim/init.lua", {})
