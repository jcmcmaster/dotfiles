vim.pack.add {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    branch = 'main'
  },
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'
}

local servers = {
  'bash',
  'bicep',
  'c',
  'cpp',
  'c_sharp',
  'css',
  'csv',
  'diff',
  'dockerfile',
  'editorconfig',
  'fsharp',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'gleam',
  'go',
  'graphql',
  'helm',
  'html',
  'hurl',
  'java',
  'javadoc',
  'javascript',
  'jq',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'powershell',
  'python',
  'regex',
  'terraform',
  'typescript',
  'vim',
  'vimdoc',
  'yaml'
}

local treesitter = require('nvim-treesitter')
treesitter.setup()
treesitter.install(servers)

require('nvim-treesitter-textobjects').setup()

local set_select = function(maps, selection)
  vim.keymap.set(
    { 'x', 'o' },
    maps,
    function()
      require("nvim-treesitter-textobjects.select").select_textobject(selection, "textobjects")
    end
  )
end

set_select('af', '@function.outer')
set_select('if', '@function.outer')
set_select('ac', '@class.outer')
set_select('ic', '@class.inner')
set_select('as', '@statement.outer')
set_select('is', '@statement.inner')
set_select('al', '@loop.outer')
set_select('il', '@loop.inner')

vim.api.nvim_create_autocmd('FileType', {
  pattern = servers,
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
  end
})
