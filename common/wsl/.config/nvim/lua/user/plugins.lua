local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

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

-- !! the float window would automatically lose focus, never to be focused again. disabling this for now cuz that's a pain.
-- packer.init {
--     display = {
--         open_fn = function()
--             return require("packer.util").float { border = "rounded" }
--         end,
--     },
-- }

return require('packer').startup({function(use)
    use 'airblade/vim-gitgutter'
    use 'arcticicestudio/nord-vim'
    use 'christoomey/vim-tmux-navigator'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'junegunn/fzf.vim'
    use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require'nvim-tree'.setup {
                --open_on_setup = true,
                auto_close = false,
                view = {
                    auto_resize = true,
                }
            }
        end
    }
    use 'neovim/nvim-lspconfig'
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
    use 'williamboman/nvim-lsp-installer'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end})
