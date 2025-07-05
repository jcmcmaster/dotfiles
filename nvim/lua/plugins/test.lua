return {
  "nvim-neotest/neotest",
  dependencies = {
    "nsidorenco/neotest-vstest",
    "Issafalcon/neotest-dotnet",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-dotnet"),
        require("neotest-vstest")
      }
    })

    vim.keymap.set("n", "<leader>td", function() require('neotest').run.run(vim.fn.getcwd()) end)
    vim.keymap.set("n", "<leader>tf", function() require('neotest').run.run(vim.fn.expand("%")) end)
    vim.keymap.set("n", "<leader>tr", function() require('neotest').run.run() end)
    vim.keymap.set("n", "<leader>to", function() require('neotest').output_panel.open() end)
    vim.keymap.set("n", "<leader>ts", function() require('neotest').summary.open() end)
  end
}
