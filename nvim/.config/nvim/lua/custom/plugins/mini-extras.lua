-- Module bổ sung của mini.nvim (mini.nvim đã được cài trong init.lua)

-- Tô màu ngay trên mã hex (#rrggbb), hữu ích cho waybar/rofi/theme Catppuccin
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
