vim.pack.add({
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/olimorris/codecompanion.nvim'
})

require('copilot').setup()
require('codecompanion').setup({
  interactions = {
    chat = {
      adapter = {
        name = "copilot",
        model = "opus-4.6"
      }
    },
    cli = {
      agent = "copilot",
      agents = {
        copilot = {
          cmd = "copilot",
          args = {},
          description = "Copilot CLI",
          provider = "terminal"
        }
      }
    }
  }
})

vim.keymap.set('n', '<leader>ac', ':CodeCompanion chat<CR>')
vim.keymap.set('n', '<leader>ai', ':CodeCompanionCLI<CR>')
