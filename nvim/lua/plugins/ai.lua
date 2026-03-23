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
      acp_providers = {
        ['copilot-cli'] = {
          command = (function()
            local paths = vim.fn.exepath('copilot')
            if paths ~= '' and not paths:match('^/mnt/c') then return paths end
            -- Fall back to nvm-managed copilot on WSL
            local nvm_bin = vim.env.NVM_DIR and vim.env.NVM_DIR .. '/versions/node'
            if nvm_bin then
              local glob = vim.fn.glob(nvm_bin .. '/*/bin/copilot', false, true)
              for i = #glob, 1, -1 do
                if not glob[i]:match('^/mnt/c') then return glob[i] end
              end
            end
            return 'copilot'
          end)(),
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
