---@diagnostic disable: missing-fields
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
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
          'yaml',
        },
        sync_install = false,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['as'] = '@statement.outer',
              ['is'] = '@statement.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
            }
          },
        },
      }
    end
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' }
}
