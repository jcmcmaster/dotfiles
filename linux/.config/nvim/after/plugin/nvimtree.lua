require('nvim-tree').setup({
  view = {
    width = 40,
  }
})

vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>")
