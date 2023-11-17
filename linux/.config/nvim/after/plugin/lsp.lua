local lsp = require("lsp-zero")

lsp.preset("recommended")

local language_servers = {
  'bashls',
  'bicep',
  'csharp_ls',
  'cssls',
  'dockerls',
  'eslint',
  'fsautocomplete',
  'html',
  'jsonls',
  'lua_ls',
  'pyright',
  'tsserver',
  'rust_analyzer',
  'vimls',
  'lemminx',
  'yamlls',
}

lsp.ensure_installed(language_servers)

lsp.setup_servers(language_servers)

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require('luasnip')
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item(cmp_select)
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
  ['<C-n>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item(cmp_select)
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

local attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.g["test#strategy"] = "neovim"
  vim.g["test#neovim#start_normal"] = 1

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

lsp.on_attach(attach)

-- Language-specific
local rust_tools = require('rust-tools')
rust_tools.setup({
  server = {
    on_attach = attach,
  },
});

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})
