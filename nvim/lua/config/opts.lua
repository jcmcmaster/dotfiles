-- Neovim options and settings configuration
-- This module configures all core vim options for optimal development experience

return {
  setup = function()
    -- Indentation settings
    vim.opt.smartindent = true     -- Smart auto-indenting
    vim.opt.expandtab = true       -- Use spaces instead of tabs
    vim.opt.smarttab = true        -- Smart tab handling
    vim.opt.tabstop = 2           -- Number of spaces per tab
    vim.opt.shiftwidth = 2        -- Number of spaces for auto-indentation
    vim.opt.softtabstop = 2       -- Number of spaces for tab in insert mode

    -- Scrolling and wrapping
    vim.opt.scrolloff = 8         -- Keep 8 lines visible when scrolling
    vim.opt.wrap = false          -- Don't wrap long lines

    -- File handling
    vim.opt.swapfile = false      -- Don't create swap files
    vim.opt.backup = false        -- Don't create backup files
    vim.opt.undofile = true       -- Enable persistent undo

    -- UI improvements
    vim.opt.confirm = true        -- Confirm before closing unsaved files
    vim.opt.signcolumn = 'yes'    -- Always show sign column (for LSP, git, etc.)
    vim.opt.termguicolors = true  -- Enable 24-bit RGB colors

    -- Search settings
    vim.opt.ignorecase = true     -- Case-insensitive search
    vim.opt.smartcase = true      -- Case-sensitive if uppercase is used
    vim.opt.incsearch = true      -- Show search results as you type

    -- File name settings
    vim.opt.isfname:append('@-@') -- Include @ in file names

    -- Mouse support
    vim.opt.mouse = 'a'           -- Enable mouse in all modes

    -- Line numbers
    vim.opt.relativenumber = true -- Show relative line numbers
    vim.opt.number = true         -- Show current line number

    -- Windows PowerShell integration
    -- Configure shell settings for Windows development
    vim.opt.shell = 'pwsh'
    vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
    vim.opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
    vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''
  end
}
