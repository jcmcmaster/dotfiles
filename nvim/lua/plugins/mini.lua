local function configure_mini_pick()
  -- configure ripgrep defaults to search the way i want for mini.pick
  -- see: https://github.com/echasnovski/mini.nvim/blob/48f48e4b3f317e9da34ee7a01958b4c5018e2d34/doc/mini-pick.txt#L1138
  local ripgreprc_path = vim.fn.stdpath("data") .. "/.ripgreprc"
  local file = io.open(ripgreprc_path, "w")
  if file then
    file:write([[
      --hidden
      ]])
    file:close()
  else
    print("Failed to write .ripgreprc file")
  end
  vim.env.RIPGREP_CONFIG_PATH = ripgreprc_path

  vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>")
  vim.keymap.set("n", "<leader>fc", ":Pick commands<CR>")
  vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
  vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
  vim.keymap.set("n", "<leader>fh", ":Pick help<CR>")
  vim.keymap.set("n", "<leader>fi", ":Pick git_files<CR>")
  vim.keymap.set("n", "<leader>fl", ":Pick git_commits<CR>")
  vim.keymap.set("n", "<leader>fo", ":Pick options<CR>")
  vim.keymap.set("n", "<leader>fr", ":Pick registers<CR>")
  vim.keymap.set("n", "<leader>ft", ":Pick treesitter<CR>")
end

local function configure_mini_files()
  vim.keymap.set("n", "<leader>e.", ":e .<CR>")
  vim.keymap.set("n", "<leader>ef", function() require('mini.files').open() end)
end

local mini_starter_config = {
  header =
  [[
   ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
   │││├┤ │ │╰┐┌╯││││
   ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴
  ]],
  footer =
  [[
  ~=================~
  ]]
}

return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require("mini.ai").setup()
    require("mini.animate").setup()
    require("mini.bracketed").setup()
    require("mini.comment").setup()
    require("mini.cursorword").setup()
    require("mini.diff").setup()
    require("mini.extra").setup()
    require("mini.files").setup()
    configure_mini_files()
    require("mini.icons").setup()
    require("mini.indentscope").setup()
    require("mini.pick").setup()
    configure_mini_pick()
    require("mini.starter").setup(mini_starter_config)
    require("mini.statusline").setup()
    require("mini.surround").setup()
    require("mini.tabline").setup()
  end
}
