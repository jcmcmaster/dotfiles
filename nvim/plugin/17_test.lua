---@diagnostic disable: missing-fields

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

-- ts = test suite        run the whole solution
vim.keymap.set('n', '<leader>ts', function() require('neotest').run.run({ suite = true }) end)
-- tf = test file         run tests in the current file
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end)
-- tn = test nearest      run the test nearest to the cursor
vim.keymap.set('n', '<leader>tn', function() require('neotest').run.run() end)
-- tr = test re-run       re-run the last test position
vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run_last() end)
-- td = test directory    run tests in the current file's directory
vim.keymap.set('n', '<leader>td', function() require('neotest').run.run(vim.fn.expand('%:p:h')) end)
-- tk = test kill         stop the running test process
vim.keymap.set('n', '<leader>tk', function() require('neotest').run.stop() end)
-- ta = test attach       attach to a running test process's terminal
vim.keymap.set('n', '<leader>ta', function() require('neotest').run.attach() end)
-- tg = test debug (gdb)  debug the nearest test with the dap strategy
vim.keymap.set('n', '<leader>tg', function() require('neotest').run.run({ strategy = 'dap' }) end)
-- to = test output       open the persistent output panel
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.open() end)
-- tm = test menu (summary) toggle the neotest summary sidebar
vim.keymap.set('n', '<leader>tm', function() require('neotest').summary.toggle() end)
