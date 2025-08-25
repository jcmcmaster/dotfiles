-- Test runner configuration with Neotest
-- Provides integrated testing support with Visual Studio Test adapter
-- See: https://github.com/nvim-neotest/neotest

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nsidorenco/neotest-vstest',      -- Visual Studio Test adapter for .NET
    'nvim-neotest/nvim-nio',          -- Async I/O library
    'nvim-lua/plenary.nvim',          -- Lua utility functions
    'antoinemadec/FixCursorHold.nvim', -- Fix for CursorHold autocmd
    'nvim-treesitter/nvim-treesitter' -- Syntax highlighting and parsing
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-vstest')  -- Enable Visual Studio Test adapter
      }
    })

    -- Key mappings for test operations
    vim.keymap.set('n', '<leader>td', function() require('neotest').run.run(vim.fn.getcwd()) end)  -- Run all tests in directory
    vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end) -- Run tests in current file
    vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run() end)                   -- Run nearest test
    vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.open() end)        -- Open test output panel
    vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.open() end)             -- Open test summary
  end
}
