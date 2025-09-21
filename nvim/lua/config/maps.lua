return {
  setup = function()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = '\\'

    -- n
    vim.keymap.set('n', '<A-Left>', ':bprevious<CR>')
    vim.keymap.set('n', '<A-Down>', ':tabnext<CR>')
    vim.keymap.set('n', '<A-Up>', ':tabprevious<CR>')
    vim.keymap.set('n', '<A-Right>', ':bnext<CR>')

    vim.keymap.set('n', '<C-Left>', ':wincmd h<CR>')
    vim.keymap.set('n', '<C-Down>', ':wincmd j<CR>')
    vim.keymap.set('n', '<C-Up>', ':wincmd k<CR>')
    vim.keymap.set('n', '<C-Right>', ':wincmd l<CR>')

    vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>')
    vim.keymap.set('n', '<S-Down>', ':resize -2<CR>')
    vim.keymap.set('n', '<S-Up>', ':resize +2<CR>')
    vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>')

    vim.keymap.set('n', '<C-S-Down>', ':split<CR>')
    vim.keymap.set('n', '<C-S-Right>', ':vsplit<CR>')

    vim.keymap.set('n', '<leader>q', ':q<CR>')
    vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
    vim.keymap.set('n', '<leader>w', ':tabc<CR>')
    vim.keymap.set('n', '<leader>x', ':bd<CR>')

    -- n, v
    vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d"]])
    vim.keymap.set({ 'n', 'v' }, '<leader>p', [["+p]])
    vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y"]])
    vim.keymap.set({ 'n', 'v' }, '<leader>Y', [["+Y"]])

    -- v
    vim.keymap.set('v', '<', '<gv')
    vim.keymap.set('v', '>', '>gv')
  end
}
