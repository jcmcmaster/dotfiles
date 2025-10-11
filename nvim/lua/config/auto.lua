local setup_format_on_save = function()
  vim.api.nvim_create_autocmd('BufWritePre', {
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
    end,
    desc = 'Auto format on save'
  })
end

return {
  setup = function()
    setup_format_on_save()
  end
}
