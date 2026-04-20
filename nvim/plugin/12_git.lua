vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit'
})

require('diffview').setup({
  view = {
    merge_tool = {
      layout = 'diff3_mixed'
    }
  }
})

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
