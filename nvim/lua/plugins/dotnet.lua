---@diagnostic disable: undefined-doc-name

local esBundlePath = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/'

return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', },
    config = function()
      require('easy-dotnet').setup()

      if vim.fn.executable('dotnet') == 1 then
        vim.fn.jobstart({ 'dotnet', 'tool', 'install', '-g', 'EasyDotnet' })
      end
    end
  },
  {
    "TheLeoP/powershell.nvim",
    ---@type powershell.user_config
    opts = {
      bundle_path = esBundlePath
    }
  }
}
