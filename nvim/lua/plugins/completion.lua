return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- sources
      'rafamadriz/friendly-snippets',
      'zbirenbaum/copilot.lua',
      'GustavEikaas/easy-dotnet.nvim',

      -- cmp source setup
      'zbirenbaum/copilot-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'abeldekat/cmp-mini-snippets',
    },
    config = function()
      local cmp = require('cmp')

      cmp.register_source('easy-dotnet', require('easy-dotnet').package_completion_source)

      cmp.setup({
        formatting = {
          format = require('lspkind').cmp_format(),
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-e>'] = cmp.mapping.abort(),
        },
        preselect = cmp.PreselectMode.Item,
        sources = {
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'easy-dotnet' },
          { name = 'nvim_lua' },
          { name = 'mini_snippets', option = { use_items_cache = false } },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'cmdline' },
        },
        window = {
          completion = cmp.config.window.bordered({ border = 'rounded' }),
          documentation = cmp.config.window.bordered({ border = 'rounded' }),
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })

      require('copilot_cmp').setup()
    end
  }
}
