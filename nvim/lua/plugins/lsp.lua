return {
  {
    'mason-org/mason.nvim',
    opts = {}
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local borderType = 'rounded'

      local function bordered_hover(_opts)
        _opts = _opts or {}
        return vim.lsp.buf.hover(vim.tbl_deep_extend('force', _opts, {
          border = borderType
        }))
      end

      local function bordered_signature_help(_opts)
        _opts = _opts or {}
        return vim.lsp.buf.signature_help(vim.tbl_deep_extend('force', _opts, {
          border = borderType
        }))
      end

      local attach = function(_client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>cf', function()
          vim.lsp.buf.format { async = true }
        end, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>h', bordered_signature_help, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', 'K', bordered_hover, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gE', vim.diagnostic.get_prev, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'ge', vim.diagnostic.get_next, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
      end

      vim.lsp.config('*', {
        on_attach = attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
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

      -- lsp is bundled with gleam
      vim.lsp.config('gleam', {
        cmd = { 'gleam', 'lsp' },
        filetypes = { 'gleam' },
        root_markers = { 'gleam.toml', '.git' }
      })

      -- mason dosn't support gleam yet
      vim.lsp.enable('gleam')

      vim.diagnostic.config({
        virtual_text = false,
        float = {
          border = borderType
        }
      })
    end
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
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
    },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
  },
  { 'onsails/lspkind.nvim' },
  { 'hrsh7th/cmp-nvim-lsp' },
}
