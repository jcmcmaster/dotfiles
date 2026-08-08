vim.pack.add({
  'https://github.com/dlyongemallo/diffview-plus.nvim',
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
