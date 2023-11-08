local autoCloseLibraryBuffersGroup = vim.api.nvim_create_augroup("AutoCloseLibraryBuffers", {});

vim.api.nvim_create_autocmd({"BufLeave"}, {
  group = autoCloseLibraryBuffersGroup,
  pattern = {"*.d.ts"},
  command = "bdelete!",
});

local autoFormatGroup = vim.api.nvim_create_augroup("AutoFormat", {});

-- automatically format Rust files with rustfmt
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  group = autoFormatGroup,
  pattern = {"*.rs", "*.fs", "*.cs"},
  command = "lua vim.lsp.buf.format()",
});

