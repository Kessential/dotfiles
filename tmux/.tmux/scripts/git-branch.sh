#!/bin/sh
# In nhánh git của thư mục $1 cho thanh tmux; thêm * nếu có thay đổi chưa commit.
cd "$1" 2>/dev/null || exit 0
b=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || exit 0
[ -n "$b" ] || exit 0
if [ -n "$(git status --porcelain --untracked-files=no 2>/dev/null | head -1)" ]; then
  printf '#[fg=#bb9af7]\356\202\240 %s#[fg=#e0af68]*#[default]  ' "$b"
else
  printf '#[fg=#bb9af7]\356\202\240 %s#[default]  ' "$b"
fi
