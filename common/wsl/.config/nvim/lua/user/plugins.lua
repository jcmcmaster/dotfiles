local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    -- vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- float the packer window with rounded border
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return require('packer').startup({function(use)
    use 'tomasiser/vim-code-dark'
    use 'airblade/vim-gitgutter'
    use 'christoomey/vim-tmux-navigator'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'junegunn/fzf.vim'
    use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
    use 'neovim/nvim-lspconfig'
    use { 'nvim-tree/nvim-tree.lua', config = function() require("nvim-tree").setup() end }
    use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'user.treesitter'
        end
    }
    use {
        'prettier/vim-prettier',
        run = "yarn install --frozen-lockfile --production",
    }
    use 'tpope/vim-commentary'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'wbthomason/packer.nvim'
    use 'will133/vim-dirdiff'
    use { 
      'williamboman/mason.nvim',
      config = function() require("mason").setup() end,
    }
    use { 
      'williamboman/mason-lspconfig.nvim',
      config = function() require("mason-lspconfig").setup() end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end})
