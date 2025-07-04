local trouble = require("trouble")
local symbols = trouble.statusline({
  mode = "lsp_document_symbols",
  groups = {},
  title = false,
  filter = { range = true },
  format = "{kind_icon}{symbol.name:Normal}",
  hl_group = "lualine_c_normal",
})

require('lualine').setup({
  extensions = { 'fugitive', 'fzf', 'mason', 'nvim-tree', 'quickfix', 'trouble' },
  sections = {
    lualine_c = {
      { symbols.get, cond = symbols.has },
    },
  },
})
