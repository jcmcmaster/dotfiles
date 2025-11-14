return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      vim.cmd [[ colorscheme tokyonight ]]
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
  }
}
