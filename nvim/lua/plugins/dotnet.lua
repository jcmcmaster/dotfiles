---@diagnostic disable: undefined-doc-name

local esBundlePath = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/'

return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', },
    config = function()
      require('easy-dotnet').setup()
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
