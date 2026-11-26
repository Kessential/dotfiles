# Tokyo Night (night) cho tmux — kiểu phẳng, không ký tự powerline
# Bản gốc có powerline: ~/.tmux/tokyonight_night.tmux.powerline

set -g mode-style "fg=#7aa2f7,bg=#3b4261"
set -g message-style "fg=#7aa2f7,bg=#3b4261"
set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#7aa2f7"

set -g status "on"
set -g status-justify "left"
set -g status-style "fg=#a9b1d6,bg=#16161e"

set -g status-left-length "100"
set -g status-right-length "100"
set -g status-left-style NONE
set -g status-right-style NONE

# Trái: tên session (khối xanh)
set -g status-left "#[fg=#16161e,bg=#7aa2f7,bold] #S #[default] "

# Phải: [PREFIX] · nhánh git · thư mục hiện tại · giờ · tên máy
set -g status-interval 5
set -g status-right "#[fg=#e0af68]#{?client_prefix,PREFIX  ,}#[default]#(~/.tmux/scripts/git-branch.sh '#{pane_current_path}')#[fg=#7dcfff]\uf07b #[fg=#a9b1d6]#{=/-45/…:#{s|^/home/[^/]*|~|:pane_current_path}} #[fg=#a9b1d6,bg=#292e42] %H:%M #[fg=#16161e,bg=#7aa2f7,bold] #h "

# Cửa sổ: thường xám, đang mở nền sáng chữ xanh
setw -g window-status-separator " "
setw -g window-status-style "fg=#565f89,bg=#16161e"
setw -g window-status-current-style "fg=#7aa2f7,bg=#292e42"
setw -g window-status-activity-style "fg=#e0af68,bg=#16161e"
setw -g window-status-format " #I #W#{?window_flags,#{window_flags}, } "
setw -g window-status-current-format "#[fg=#7aa2f7,bg=#292e42,bold] #I #W#{?window_flags,#{window_flags}, } "
