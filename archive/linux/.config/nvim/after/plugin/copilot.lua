require("copilot").setup({
  suggestion = { enabled = false }, -- see cmp config
  panel = { enabled = false }, -- see cmp config
})

require("copilot_cmp").setup() -- see cmp config

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
