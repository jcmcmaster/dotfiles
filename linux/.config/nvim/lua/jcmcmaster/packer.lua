local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    -- vim.cmd [[packadd packer.nvim]]
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
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
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
  use({
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        icons = false,
      }
    end
  })
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
  use 'theprimeagen/harpoon'
  use 'theprimeagen/refactoring.nvim'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      -- Language-specific
      { 'simrat39/rust-tools.nvim' },
    }
  }
  use('folke/zen-mode.nvim')
  use('github/copilot.vim')
  use('eandrju/cellular-automaton.nvim')
  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'haydenmeade/neotest-jest',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-jest'),
        },
        quickfix = {
          open = false
        }
      })
    end
  }
  use {
    'mxsdev/nvim-dap-vscode-js',
    requires = { 'mfussenegger/nvim-dap' },
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    config = function() require('dapui').setup() end,
  }
  use {
    'microsoft/vscode-js-debug',
    opt = true,
    run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
  }
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
