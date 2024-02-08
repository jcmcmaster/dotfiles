require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden'
    },
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--ignore', '--hidden', '--files', '--follow', '--glob', '!**/.git/*' }
    }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", builtin.registers, {})
vim.keymap.set("n", "<leader>ft", builtin.builtin, {})
