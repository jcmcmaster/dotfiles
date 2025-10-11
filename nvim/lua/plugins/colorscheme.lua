return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      vim.cmd [[ colorscheme tokyonight ]]
    end
  },
  {
    'sainnhe/everforest',
    lazy = false,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = 'hard'
      vim.cmd [[ colorscheme everforest ]]
    end
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    config = function()
      vim.cmd [[ colorscheme rose-pine ]]
    end
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    priority = 0,
    lazy = false,
    config = function()
      vim.cmd [[ colorscheme github_dark_default ]]
      vim.g.terminal_color_8 = '#6E7681' -- command opts were hard to read
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    config = function()
      vim.cmd [[ colorscheme carbonfox ]]
    end
  },
}
