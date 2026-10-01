# dotfiles

Cấu hình Linux (Fedora + Sway, theme Catppuccin Mocha), quản lý bằng [GNU Stow](https://www.gnu.org/software/stow/).
Mỗi thư mục cấp một là một "gói" stow, bên trong giữ nguyên đường dẫn so với `$HOME`
(ví dụ `sway/.config/sway/config` → `~/.config/sway/config`).

## Cài đặt

```sh
git clone git@github.com:Kessential/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo dnf install -y git stow          # tối thiểu để bắt đầu; bootstrap.sh in lệnh cho các gói còn lại

mkdir -p ~/.config ~/.local/share ~/.local/bin   # tạo trước để stow không gộp cả thư mục vào repo

# zsh và fcitx5 phải dùng --no-folding (xem "Lưu ý" bên dưới)
stow --no-folding zsh fcitx5
stow bat bottom btop eza foot gtk imv lazygit mako nvim ripgrep rofi \
     sway swaylock tmux wallpapers waybar yazi zathura

./bootstrap.sh                        # sau khi đã stow
sudo bash sddm/install.sh             # theme SDDM (không stow)
```

Sau cùng: `gh auth login`, `atuin import auto`, mở `nvim` một lần để `vim.pack` và Mason cài plugin/LSP,
trong tmux nhấn `prefix + I` nếu plugin tmux chưa có.

Nếu stow báo xung đột vì file đã tồn tại (ví dụ `~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`),
hãy chuyển file cũ đi (`mv`) rồi stow lại. Xem trước bằng `stow -n -v <gói>`.

## Các gói

| Gói | Nội dung |
|---|---|
| `sway`, `swaylock`, `waybar`, `mako`, `rofi` | Desktop Sway: cửa sổ, khoá màn hình, thanh trạng thái, thông báo, launcher |
| `foot`, `tmux`, `zsh` | Terminal, tmux (prefix là dấu `` ` ``), zsh + oh-my-zsh |
| `nvim` | Neovim dựa trên kickstart.nvim, tuỳ chỉnh thêm trong `lua/custom/plugins/` |
| `bat`, `btop`, `bottom`, `eza`, `lazygit`, `yazi`, `ripgrep`, `zathura`, `imv` | Công cụ dòng lệnh và trình xem |
| `fcitx5`, `gtk`, `wallpapers` | Bộ gõ, GTK, ảnh nền |
| `sddm` | Theme SDDM, **không** stow; cài bằng `sddm/install.sh` |

## Lưu ý

- **zsh và fcitx5 dùng `--no-folding`.** Nếu không, stow có thể symlink cả `~/.oh-my-zsh` hoặc `~/.local`
  vào repo, và oh-my-zsh, plugin zsh hay file trong `~/.local/bin` sẽ bị ghi vào cây repo.
  `bootstrap.sh` dừng lại nếu thấy `~/.oh-my-zsh` là symlink.
- **nvim thì để stow gộp thư mục** (`~/.config/nvim` là symlink vào repo), nên `nvim-pack-lock.json`
  do nvim cập nhật sẽ nằm ngay trong repo. Nhớ commit khi bạn nâng cấp plugin.
- **Plugin không nằm trong repo.** Plugin zsh và tmux (tpm) do `bootstrap.sh` clone; plugin nvim do `vim.pack` cài.
  Phiên bản plugin nvim được khoá trong `nvim/.config/nvim/nvim-pack-lock.json`.
- **Ảnh nền** dùng đường dẫn `~/Pictures/wallpapers/...` trong `sway/config` và `swaylock/config`,
  nên gói `wallpapers` phải được stow.
- **Bộ gõ tiếng Việt:** máy hiện dùng `fcitx5-lotus`, chưa được `bootstrap.sh` cài; cài riêng theo hướng dẫn của dự án đó.
- `sway/config.d/90-swayidle.conf` chỉ chứa comment, cố ý, để ghi đè file cùng tên của hệ thống.
- Không đưa `~/.config/gh` vào repo: `hosts.yml` chứa token đăng nhập.
