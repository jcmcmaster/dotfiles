local autoCloseLibraryBuffersGroup = vim.api.nvim_create_augroup("AutoCloseLibraryBuffers", {});

vim.api.nvim_create_autocmd({"BufLeave"}, {
  group = autoCloseLibraryBuffersGroup,
  pattern = {"*.d.ts"},
  command = "bdelete!",
})
