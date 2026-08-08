vim.pack.add({
  'https://github.com/vague-theme/vague.nvim'
})

require('vague').setup({
  italic = false
})

vim.cmd.colorscheme('vague')
