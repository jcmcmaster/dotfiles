vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<CR>")

require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
  }
}
