vim.keymap.set("n", "<leader>t", function() require("neotest").run.run() end, opts)
vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run(vim.fn.expand("%")) end, opts)
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, opts)
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, opts)
vim.keymap.set("n", "<leader>too", function() require("neotest").output.open() end, opts)
vim.keymap.set("n", "<leader>top", function() require("neotest").output_panel.toggle() end, opts)
vim.keymap.set("n", "<leader>tx", function() require("neotest").run.stop() end, opts)

