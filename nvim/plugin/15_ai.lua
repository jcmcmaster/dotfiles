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
          cmd = "gh",
          args = { "copilot" },
          description = "GitHub CLI Copilot",
          provider = "terminal"
        }
      }
    }
  }
})

vim.keymap.set('n', '<leader>ac', ':CodeCompanion chat<CR>')
vim.keymap.set('n', '<leader>ai', ':CodeCompanionCLI<CR>')
