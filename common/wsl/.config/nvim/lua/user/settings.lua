local opt = vim.opt

opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

vim.cmd("filetype indent plugin on")

opt.clipboard = 'unnamedplus'
vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
       ["+"] = 'clip.exe',
       ["*"] = 'clip.exe',
     },
    paste = {
       ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
       ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }

opt.confirm = true
opt.cursorcolumn = true
opt.cursorline = true
opt.encoding = 'utf-8'
opt.expandtab = true
opt.hlsearch = true
opt.ignorecase = true
opt.mouse = 'a'
opt.path = opt.path + '.,**' -- search down into subfolders, provides tab-completion for all file-related tasks
opt.relativenumber = true
opt.number = true

opt.showcmd = true
opt.splitbelow = true
opt.splitright = true
opt.wildmenu = true
