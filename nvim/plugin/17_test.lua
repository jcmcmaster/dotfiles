vim.pack.add({
  'https://github.com/nsidorenco/neotest-vstest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-neotest/neotest'
})

require('neotest').setup({
  adapters = {
    require('neotest-vstest')
  }
})

vim.keymap.set('n', '<leader>td', function() require('neotest').run.run(vim.fn.getcwd()) end)
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end)
vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end)
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.open() end)
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.open() end)
