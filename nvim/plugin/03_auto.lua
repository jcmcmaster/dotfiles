vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto format on save',
  pattern = {
    '*.bicep',
    '*.cs',
    '*.fs',
    '*.gleam',
    '*.json',
    '*.lua',
    '*.md',
    '*.ps1',
    '*.sql',
    '*.tf',
    '*.tfvars',
    '*.yaml',
    '*.yml',
  },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})
