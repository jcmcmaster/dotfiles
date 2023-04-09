-- see ./lsp.lua for lsp-specific keymaps
local opts = { noremap = true, silent = true }

vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- debugger (leader-b)
vim.keymap.set("n", "<leader>bb", function() require("dap").toggle_breakpoint() end, opts)
vim.keymap.set("n", "<leader>bl", function() require("dap").run_last() end, opts)
vim.keymap.set("n", "<leader>br", function() require("dap").repl_open() end, opts)
vim.keymap.set("n", "<leader>bui", function() require("dapui").toggle() end, opts)
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, opts)
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, opts)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, opts)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, opts)

-- diff (leader-d)
vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", opts)
vim.keymap.set("n", "<leader>dfh", ":DiffviewFileHistory<CR>", opts)

-- find (leader-f)
vim.keymap.set("n", "<leader>f", ":Telescope<CR>", opts)
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>fF", ":Telescope find_files hidden=true<CR>", opts)
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>fr", ":Telescope registers<CR>", opts)

vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", opts)

-- test (leader-t)
vim.keymap.set("n", "<leader>t", function() require("neotest").run.run() end, opts)
vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run(vim.fn.expand("%")) end, opts)
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, opts)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, opts)
vim.keymap.set("n", "<leader>too", function() require("neotest").output.open() end, opts)
vim.keymap.set("n", "<leader>top", function() require("neotest").output_panel.toggle() end, opts)
vim.keymap.set("n", "<leader>tx", function() require("neotest").run.stop() end, opts)

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

vim.api.nvim_create_user_command("Diff", "DiffviewOpen", { nargs = "*" })
vim.api.nvim_create_user_command("Rc", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Src", "source ~/.config/nvim/init.lua", {})
