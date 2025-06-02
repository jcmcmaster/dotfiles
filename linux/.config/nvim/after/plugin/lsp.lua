local language_servers = {
  'bashls',
  'bicep',
  'csharp_ls',
  'cssls',
  'dockerls',
  'eslint',
  'graphql',
  'fsautocomplete',
  'html',
  'jsonls',
  'lua_ls',
  'powershell_es',
  'pyright',
  'vimls',
  'lemminx',
  'yamlls',
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = language_servers,
}

local attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>cf', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<loader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
end

vim.lsp.config('*', {
  on_attach = attach
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
    }
  }
})

vim.diagnostic.config({
  virtual_text = true
})
