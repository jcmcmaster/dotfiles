local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
    augroup end
]]

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- float the packer window with rounded border
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
}

return require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'
  use { 'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use "folke/tokyonight.nvim"
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' }
    },
    config = function()
      require('telescope').load_extension('live_grep_args')
    end
  }
  use('folke/trouble.nvim')
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'neovim/nvim-lspconfig'
  use 'mason-org/mason.nvim'
  use 'mason-org/mason-lspconfig.nvim'
  use 'onsails/lspkind.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'
  use 'zbirenbaum/copilot.lua'
  use 'zbirenbaum/copilot-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'
  use 'folke/zen-mode.nvim'
  use 'CopilotC-Nvim/CopilotChat.nvim'
  use 'eandrju/cellular-automaton.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use {
    'prettier/vim-prettier',
    run = 'yarn install --frozen-lockfile --production',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end })
