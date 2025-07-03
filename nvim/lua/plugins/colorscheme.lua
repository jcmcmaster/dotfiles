return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[ colorscheme tokyonight ]]
    end
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 999,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = "medium"
      vim.cmd [[ colorscheme everforest ]]
    end
  }
}
