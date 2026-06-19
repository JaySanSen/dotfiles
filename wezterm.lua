local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'GruvboxDarkHard'
config.color_scheme = 'rose-pine'
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold'})
config.font_size = 16
config.audible_bell = "Disabled"
config.initial_rows = 30
config.initial_cols = 100
config.default_cursor_style = 'SteadyBlock'

return config
