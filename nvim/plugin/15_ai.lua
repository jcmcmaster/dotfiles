vim.pack.add({
  'https://github.com/github/copilot.vim',
  {
    src = "https://github.com/nickjvandyke/opencode.nvim",
    version = vim.version.range("*"), -- Latest stable release
  },
})

vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end, { desc = "Select OpenCode…" })

vim.keymap.set("n", "<leader>ak", function() require("opencode").command("session.half.page.up") end,
  { desc = "Scroll OpenCode up" })
vim.keymap.set("n", "<leader>aj", function() require("opencode").command("session.half.page.down") end,
  { desc = "Scroll OpenCode down" })

vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
  { desc = "Append range to OpenCode", expr = true })
vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
  { desc = "Append line to OpenCode", expr = true })
