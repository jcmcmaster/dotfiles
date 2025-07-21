return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'echasnovski/mini.pick',
    'nvim-tree/nvim-web-devicons'
  },
  config = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
  end
}
