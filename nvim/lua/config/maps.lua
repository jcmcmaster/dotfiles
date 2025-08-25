-- Key mappings and shortcuts configuration
-- This module defines all custom key bindings for enhanced productivity

return {
  setup = function()
    -- Leader keys
    vim.g.mapleader = ' '         -- Space as leader key
    vim.g.maplocalleader = '\\'   -- Backslash as local leader

    -- Buffer and tab navigation
    vim.keymap.set('n', '<A-Left>', ':bprevious<CR>')   -- Previous buffer
    vim.keymap.set('n', '<A-Down>', ':tabnext<CR>')     -- Next tab
    vim.keymap.set('n', '<A-Up>', ':tabprevious<CR>')   -- Previous tab
    vim.keymap.set('n', '<A-Right>', ':bnext<CR>')      -- Next buffer

    -- Window navigation
    vim.keymap.set('n', '<C-Left>', ':wincmd h<CR>')    -- Move to left window
    vim.keymap.set('n', '<C-Down>', ':wincmd j<CR>')    -- Move to bottom window
    vim.keymap.set('n', '<C-Up>', ':wincmd k<CR>')      -- Move to top window
    vim.keymap.set('n', '<C-Right>', ':wincmd l<CR>')   -- Move to right window

    -- Window resizing
    vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>')   -- Decrease width
    vim.keymap.set('n', '<S-Down>', ':resize -2<CR>')           -- Decrease height
    vim.keymap.set('n', '<S-Up>', ':resize +2<CR>')             -- Increase height
    vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>') -- Increase width

    -- Window splitting
    vim.keymap.set('n', '<C-S-Down>', ':split<CR>')     -- Horizontal split
    vim.keymap.set('n', '<C-S-Right>', ':vsplit<CR>')   -- Vertical split

    -- Search and replace - find and replace word under cursor
    vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

    -- Clipboard operations (system clipboard integration)
    vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d"]])  -- Delete without yanking
    vim.keymap.set({ 'n', 'v' }, '<leader>p', [["+p]])   -- Paste from system clipboard
    vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y"]])  -- Yank to system clipboard
    vim.keymap.set({ 'n', 'v' }, '<leader>Y', [["+Y"]])  -- Yank line to system clipboard

    -- Visual mode enhancements
    vim.keymap.set('v', '<', '<gv')   -- Keep selection when indenting left
    vim.keymap.set('v', '>', '>gv')   -- Keep selection when indenting right
  end
}
