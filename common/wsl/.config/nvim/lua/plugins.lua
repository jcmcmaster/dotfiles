local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'airblade/vim-gitgutter'
  use 'christoomey/vim-tmux-navigator'
  use 'dunstontc/vim-vscode-theme'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'junegunn/fzf.vim'
  use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use 'neovim/nvim-lspconfig'
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'scrooloose/nerdtree'
  use 'sheerun/vim-polyglot'
  use 'tomasiser/vim-code-dark'
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'wbthomason/packer.nvim'
  use 'will133/vim-dirdiff'
  use 'williamboman/nvim-lsp-installer'
  use 'xolox/vim-misc'
  use 'xolox/vim-notes'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
