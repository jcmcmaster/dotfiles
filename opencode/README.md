# OpenCode

`opencode.jsonc` contains server settings. `cli.json` contains terminal keybinding
overrides and belongs at `~/.config/opencode/cli.json` (or
`$XDG_CONFIG_HOME/opencode/cli.json`). OpenCode does not load project-local CLI
settings. Merge the `keybinds` object into an existing global CLI config to retain
its other preferences. Valid edits reload automatically.

To preview the overrides without changing your global config, run from the
dotfiles repository root:

```sh
OPENCODE_CLI_CONFIG_CONTENT="$(cat opencode/cli.json)" opencode
```

## Tab and buffer navigation

OpenCode session tabs are the closest equivalent to Neovim's buffers and tab
pages. Use only Alt+Left/Right for previous/next-tab navigation, matching the
buffer-navigation keys in `nvim/plugin/02_map.lua`:

| Keys | Action |
|---|---|
| Alt+Left | Previous session tab |
| Alt+Right | Next session tab |
| Ctrl+X, then W | Close the current tab without deleting the session (default) |
| Ctrl+X, then L | List sessions (default) |
| Ctrl+Shift+T | Reopen the last closed tab (default) |

The tab overrides replace the default Alt+Up/Down and Ctrl+Tab/Ctrl+Shift+Tab
bindings rather than adding alternatives.

Alt+Left/Right are removed from prompt word navigation so they do not conflict
with tab switching. Alt+B/F and Ctrl+Left/Right still move by word. Inside the
diff viewer, Alt+Up/Down retain their default previous/next-file behavior.

The leader remains OpenCode's default Ctrl+X rather than Neovim's Space, which is
needed for typing prompts. Neovim's `<leader>w` already has a direct equivalent;
its multi-key `<leader>bd` and `<leader>fb` sequences are not ported because the
OpenCode keybind reference does not document multi-key sequences after a leader.
Use the default close/list shortcuts above instead.
