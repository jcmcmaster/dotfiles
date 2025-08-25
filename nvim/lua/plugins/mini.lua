-- Mini.nvim plugin suite configuration
-- Comprehensive collection of essential Neovim plugins in one package
-- See: https://github.com/echasnovski/mini.nvim

-- Setup function for mini.diff - Git difference visualization
local function setup_mini_diff()
  require('mini.diff').setup()
  local diff = require('mini.diff')
  diff.setup({
    source = diff.gen_source.none()  -- Disable automatic diff source
  })
end

-- Setup function for mini.files - File explorer
local function setup_mini_files()
  require('mini.files').setup({
    mappings = {
      go_in = '<Right>',   -- Enter directory/open file with right arrow
      go_out = '<Left>'    -- Go up directory with left arrow
    }
  })
  -- Key mappings for file exploration
  vim.keymap.set('n', '<leader>e.', ':e .<CR>')  -- Open current directory in Neovim
  vim.keymap.set('n', '<leader>ef', function() require('mini.files').open() end)  -- Open mini.files
end

-- Setup function for mini.pick - Fuzzy finder and picker
local function setup_mini_pick()
  require('mini.pick').setup()
  -- Configure ripgrep defaults for better search experience
  -- see: https://github.com/echasnovski/mini.nvim/blob/48f48e4b3f317e9da34ee7a01958b4c5018e2d34/doc/mini-pick.txt#L1138
  local ripgreprc_path = vim.fn.stdpath('data') .. '/.ripgreprc'
  local file = io.open(ripgreprc_path, 'w')
  if file then
    file:write([[
      --hidden
      --smart-case
      ]])
    file:close()
  else
    print('Failed to write .ripgreprc file')
  end
  vim.env.RIPGREP_CONFIG_PATH = ripgreprc_path

  vim.keymap.set('n', '<leader>fb', ':Pick buffers<CR>')
  vim.keymap.set('n', '<leader>fc', ':Pick commands<CR>')
  vim.keymap.set('n', '<leader>fe', ':Pick explorer<CR>')
  vim.keymap.set('n', '<leader>ff', ':Pick files<CR>')
  vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>')
  vim.keymap.set('n', '<leader>fh', ':Pick help<CR>')
  vim.keymap.set('n', '<leader>fi', ':Pick git_files<CR>')
  vim.keymap.set('n', '<leader>fl', ':Pick git_commits<CR>')
  vim.keymap.set('n', '<leader>fo', ':Pick options<CR>')
  vim.keymap.set('n', '<leader>fr', ':Pick registers<CR>')
  vim.keymap.set('n', '<leader>ft', ':Pick treesitter<CR>')
end

-- Main mini.nvim plugin configuration
return {
  'echasnovski/mini.nvim',
  version = false,  -- Use HEAD for latest features
  config = function()
    -- Core mini.nvim modules - each provides essential functionality
    require('mini.ai').setup()           -- Advanced text objects (around/inside)
    require('mini.bracketed').setup()    -- Navigate through various brackets
    require('mini.comment').setup()      -- Smart commenting with gc
    require('mini.cursorword').setup()   -- Highlight word under cursor
    setup_mini_diff()                    -- Git diff integration
    require('mini.extra').setup()        -- Extra pickers and utilities
    setup_mini_files()                   -- File explorer
    require('mini.icons').setup()        -- File and folder icons
    require('mini.indentscope').setup()  -- Visual indent guides
    setup_mini_pick()                    -- Fuzzy finder with custom config
    require('mini.snippets').setup()     -- Code snippets support
    require('mini.statusline').setup()   -- Minimal status line
    require('mini.surround').setup()     -- Surround text objects (quotes, brackets, etc.)
    require('mini.tabline').setup()      -- Buffer tabs at the top
  end
}
