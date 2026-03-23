return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({})
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    build = vim.fn.has('win32') ~= 0
        and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
        or 'make',
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'copilot',
      mode = 'agentic',
      default_model = 'opus-4.6',
      acp_providers = {
        ['copilot-cli'] = {
          command = 'copilot',
          args = { '--acp', '--stdio' },
        },
      },
    },
    config = function(_, opts)
      require('avante').setup(opts)
      vim.keymap.set('n', '<leader>az', function()
        require('avante.api').zen_mode()
      end, { desc = 'Avante zen mode' })
      vim.cmd([[cab cc Avante]])
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'zbirenbaum/copilot.lua',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
