local opt = vim.opt

opt.clipboard = 'unnamedplus'
opt.tabstop = 4
opt.softtabstop = 0
opt.expandtab = true
opt.shiftwidth = 4
opt.smarttab = true
opt.encoding = 'utf-8'
opt.background = 'dark'
opt.hlsearch = true
opt.showcmd = true
opt.wildmenu = true
opt.relativenumber = true
opt.ignorecase = true
opt.autoindent = true
opt.confirm = true
opt.path = vim.opt.path + '.,**' -- search down into subfolders, provides tab-completion for all file-related tasks
opt.clipboard = 'unnamedplus'
opt.splitbelow = true
opt.splitright = true
opt.cursorline = true
opt.cursorcolumn = true
opt.mouse = 'a'