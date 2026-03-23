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
        and (function()
          local shell = vim.fn.exepath('pwsh')
          if shell == '' then shell = vim.fn.exepath('powershell') end
          if shell == '' then shell = 'pwsh' end
          return vim.fn.shellescape(shell)
            .. ' -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
        end)()
        or 'make',
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'copilot',
      mode = 'agentic',
      default_model = 'opus-4.6',
    },
    config = function(_, opts)
      -- Resolve WSL-native copilot binary at load time (not startup)
      -- so NVM_DIR is guaranteed to be set
      local copilot_bin = vim.fn.exepath('copilot')
      if copilot_bin == '' or copilot_bin:match('^/mnt/c') then
        local nvm_bin = vim.env.NVM_DIR and vim.env.NVM_DIR .. '/versions/node'
        if nvm_bin then
          local glob = vim.fn.glob(nvm_bin .. '/*/bin/copilot', false, true)
          for i = #glob, 1, -1 do
            if not glob[i]:match('^/mnt/c') then
              copilot_bin = glob[i]
              break
            end
          end
        end
        if copilot_bin == '' or copilot_bin:match('^/mnt/c') then
          copilot_bin = 'copilot'
        end
      end
      opts.acp_providers = {
        ['copilot-cli'] = {
          command = copilot_bin,
          args = { '--acp', '--stdio' },
        },
      }
      require('avante').setup(opts)
      vim.keymap.set('n', '<leader>az', function()
        require('avante.api').zen_mode()
      end, { desc = 'Avante zen mode' })
      vim.api.nvim_create_user_command('AvanteZen', function()
        require('avante.api').zen_mode()
      end, { desc = 'Open Avante in zen mode' })
      vim.cmd([[cabbrev av Avante]])
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'zbirenbaum/copilot.lua',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
