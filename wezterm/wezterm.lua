local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'rose-pine'
config.default_prog = { '/etc/profiles/per-user/' .. os.getenv('USER') .. '/bin/fish', '-l' }
config.font_size = 12
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.max_fps = 120

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
