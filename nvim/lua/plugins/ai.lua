return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        prompts = {
          Explain = {
            prompt = 'Please explain the selected code.',
            system_prompt = 'COPILOT_EXPLAIN'
          }
        },
        selection = function(source)
          return select.visual(source) or select.buffer(source)
        end
      })

      vim.keymap.set({ "n", "v" }, "<leader>ac", ":CopilotChat<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>ao", ":CopilotChatOptimize<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>ae", ":CopilotChatExplain<CR>")
    end
  },
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- see cmp config
        panel = { enabled = false },      -- see cmp config
      })
    end
  }
}
