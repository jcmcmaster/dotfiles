return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- sources
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'zbirenbaum/copilot.lua',
      'CopilotC-Nvim/CopilotChat.nvim',

      -- cmp source setup
      'zbirenbaum/copilot-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'zbirenbaum/copilot-cmp',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        formatting = {
          format = require('lspkind').cmp_format(),
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-e>'] = cmp.mapping.abort(),
        },
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
          end
        },
        sources = {
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'nvim_lua', group_index = 2 },
          { name = 'path',     group_index = 2 },
          { name = 'buffer',   group_index = 2 },
          { name = 'cmdline',  group_index = 2 },
          { name = 'luasnip',  group_index = 2 },
          { name = 'copilot',  group_index = 1 },
        },
        window = {
          completion = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
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

      require("copilot_cmp").setup() -- see cmp config
    end
  },
}
