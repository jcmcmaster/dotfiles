-- Bootstrap lazy.nvim plugin manager
-- This will automatically install lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration modules
require('config.opts').setup()  -- Vim options and settings
require('config.maps').setup()  -- Key mappings and shortcuts
require('config.auto').setup()  -- Autocommands and startup screen

-- Initialize lazy.nvim with plugin specifications
require('lazy').setup({
  spec = {
    { import = 'plugins' },  -- Load all plugins from the plugins/ directory
  },
  checker = { enabled = true },  -- Enable automatic plugin update checking
})
