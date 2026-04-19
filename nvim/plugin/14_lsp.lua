vim.pack.add({ 
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/onsails/lspkind.nvim'
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})

vim.keymap.set('n', '<C-.>', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format { async = true }
end)
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

vim.lsp.enable({
  'bashls',
  'bicep',
  'csharp_ls',
  'cssls',
  'dockerls',
  'eslint',
  'fsautocomplete',
  'graphql',
  'html',
  'jsonls',
  'lemminx',
  'lua_ls',
  'powershell_es',
  'pyright',
  'vimls',
  'yamlls'
})
