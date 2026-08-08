vim.pack.add({
  'https://github.com/vague-theme/vague.nvim'
})

require('vague').setup({
  italic = false
})

vim.cmd.colorscheme('vague')

vim.api.nvim_set_hl(0, 'MiniTablineCurrent', { fg = '#cdcdcd' })
