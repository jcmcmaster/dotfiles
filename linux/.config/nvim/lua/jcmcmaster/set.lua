vim.opt.smartindent = true

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.clipboard = 'unnamedplus'
-- vim.g.clipboard = {
--     name = 'WslClipboard',
--     copy = {
--        ["+"] = 'clip.exe',
--        ["*"] = 'clip.exe',
--      },
--     paste = {
--        ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--        ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = 0,
--   }

vim.opt.confirm = true

vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

vim.opt.ignorecase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.isfname:append("@-@")

vim.opt.mouse = 'a'

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.scrolloff = 8
