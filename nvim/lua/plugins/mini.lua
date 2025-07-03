return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require("mini.ai").setup()
      require("mini.animate").setup()
      require("mini.bracketed").setup()
      require("mini.comment").setup()
      require("mini.cursorword").setup()
      require("mini.diff").setup()
      require("mini.extra").setup()
      require("mini.files").setup()
      require("mini.icons").setup()
      require("mini.indentscope").setup()
      require("mini.pick").setup()
      require("mini.starter").setup()
      require("mini.statusline").setup()
      require("mini.surround").setup()
      require("mini.tabline").setup()

      -- mini.pick
      vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>")
      vim.keymap.set("n", "<leader>fc", ":Pick commands<CR>")
      vim.keymap.set("n", "<leader>ff", ":Pick git_files<CR>")
      vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
      vim.keymap.set("n", "<leader>fh", ":Pick help<CR>")
      vim.keymap.set("n", "<leader>fl", ":Pick git_commits<CR>")
      vim.keymap.set("n", "<leader>fo", ":Pick options<CR>")
      vim.keymap.set("n", "<leader>fr", ":Pick registers<CR>")
      vim.keymap.set("n", "<leader>ft", ":Pick treesitter<CR>")
    end
  }
}
