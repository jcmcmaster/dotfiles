return {
  setup = function()
    vim.opt.smartindent = true

    vim.opt.expandtab = true
    vim.opt.smarttab = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2

    vim.opt.scrolloff = 8
    vim.opt.wrap = false

    vim.opt.swapfile = false
    vim.opt.backup = false
    vim.opt.undofile = true

    vim.opt.autoread = true

    vim.opt.confirm = true

    vim.opt.signcolumn = 'yes'
    vim.opt.termguicolors = true

    vim.opt.ignorecase = true
    vim.opt.smartcase = true

    vim.opt.incsearch = true

    vim.opt.isfname:append('@-@')

    vim.opt.mouse = 'a'

    vim.opt.relativenumber = true
    vim.opt.number = true

    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      vim.opt.shell = 'pwsh'
      vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
      vim.opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
      vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
      vim.opt.shellquote = ''
      vim.opt.shellxquote = ''
    end
  end
}
