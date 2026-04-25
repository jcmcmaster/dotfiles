local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = 'rose-pine'
config.default_prog = { '/Users/' .. os.getenv('USER') .. '/.nix-profile/bin/fish', '-l' }
config.font_size = 12
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.max_fps = 120

config.keys = {
  -- disable defaults
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment
  },
  -- moving between panes
  {
    key = 'Home',
    mods = 'CTRL',
    action = act.ActivatePaneDirection('Left')
  },
  {
    key = 'End',
    mods = 'CTRL',
    action = act.ActivatePaneDirection('Right')
  },
  {
    key = 'PageUp',
    mods = 'CTRL',
    action = act.ActivatePaneDirection('Up')
  },
  {
    key = 'PageDown',
    mods = 'CTRL',
    action = act.ActivatePaneDirection('Down')
  },
  -- resizing panes
  {
    key = 'Home',
    mods = 'SHIFT',
    action = act.AdjustPaneSize({ 'Left', 5 })
  },
  {
    key = 'End',
    mods = 'SHIFT',
    action = act.AdjustPaneSize({ 'Right', 5 })
  },
  {
    key = 'PageUp',
    mods = 'SHIFT',
    action = act.AdjustPaneSize({ 'Up', 5 })
  },
  {
    key = 'PageDown',
    mods = 'SHIFT',
    action = act.AdjustPaneSize({ 'Down', 5 })
  },
  -- moving between tabs
  {
    key = 'Home',
    mods = 'OPT',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'End',
    mods = 'OPT',
    action = act.ActivateTabRelative(1)
  },
  -- creating panes
  {
    key = 'End',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal
  },
  {
    key = 'PageDown',
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical
  },
  -- rotating panes
  {
    key = 'Home',
    mods = 'CTRL|SHIFT|OPT',
    action = act.RotatePanes('CounterClockwise')
  },
  {
    key = 'End',
    mods = 'CTRL|SHIFT|OPT',
    action = act.RotatePanes('Clockwise')
  }
}

wezterm.on("gui-startup", function(cmd)
  local screen            = wezterm.gui.screens().active
  local ratio             = 0.7
  local width, height     = screen.width * ratio, screen.height * ratio
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = 'ActiveScreen' }
  }
  window:gui_window():set_inner_size(width, height)
end)

return config
