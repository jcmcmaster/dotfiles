return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- see cmp config
        panel = { enabled = false },      -- see cmp config
      })
    end
  },
  {
    "yetone/avante.nvim",
    build = function()
      if vim.fn.has("win32") == 1 then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        return "make"
      end
    end,
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type avante.Config
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-4",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 2048,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "hrsh7th/nvim-cmp",
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
