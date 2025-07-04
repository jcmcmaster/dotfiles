local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true no_ignore=true no_ignore_parent=true follow=true<CR>", {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fG", ":Telescope live_grep_args<CR>", {})
vim.keymap.set("n", "<leader>fr", builtin.registers, {})
vim.keymap.set("n", "<leader>ft", builtin.builtin, {})

require("telescope").setup {
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        },
    },
}
