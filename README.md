# dotfiles

Cấu hình Linux (Fedora + Sway, theme Tokyo Night (night)), quản lý bằng [GNU Stow](https://www.gnu.org/software/stow/).
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
stow bat btop delta eza foot gtk imv lazygit mako nvim qt ripgrep rofi \
     sway swaylock tmux waybar yazi zathura

./bootstrap.sh                        # sau khi đã stow
sudo bash sddm/install.sh             # theme SDDM Tokyo Night (không stow)
```

Sau cùng: `gh auth login`, mở `nvim` một lần để `vim.pack` và Mason cài plugin/LSP,
trong tmux nhấn `prefix + I` nếu plugin tmux chưa có.

Nếu stow báo xung đột vì file đã tồn tại (ví dụ `~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`),
hãy chuyển file cũ đi (`mv`) rồi stow lại. Xem trước bằng `stow -n -v <gói>`.

## Các gói

| Gói | Nội dung |
|---|---|
| `sway`, `swaylock`, `waybar`, `mako`, `rofi` | Desktop Sway: cửa sổ, khoá màn hình, thanh trạng thái, thông báo, launcher |
| `foot`, `tmux`, `zsh` | Terminal, tmux (prefix là `Ctrl-a`), zsh + oh-my-zsh |
| `nvim` | Neovim dựa trên kickstart.nvim, tuỳ chỉnh thêm trong `lua/custom/plugins/` |
| `bat`, `btop`, `eza`, `lazygit`, `yazi`, `ripgrep`, `zathura`, `imv` | Công cụ dòng lệnh và trình xem |
| `fcitx5`, `gtk`, `qt` | Bộ gõ, GTK, bảng màu Qt cho qt5ct/qt6ct |
| `delta` | Màu diff cho git delta, cần include trong `~/.gitconfig` (xem Lưu ý) |
| `sddm` | Theme SDDM, **không** stow; cài bằng `sddm/install.sh` |

## Lưu ý

- **Theme Tokyo Night.** Phần lớn file màu lấy từ `extras/` của plugin `folke/tokyonight.nvim`
  (foot, tmux, fzf, bat, delta, eza, lazygit, yazi, btop, zathura). Các file còn lại (sway, waybar, rofi,
  mako, swaylock, imv, zsh-syntax-highlighting, Qt) viết tay theo cùng bảng màu.
- **git delta:** `.gitconfig` không nằm trong repo (có tên/email), nên thêm tay:
  `git config --global include.path ~/.config/delta/tokyonight_night.gitconfig`.
- **Ngoài repo:** VS Code dùng extension `enkia.tokyo-night`.
- **Theme GTK Tokyonight-Dark** (bản `black`, repo Fausto-Korpsvart/Tokyonight-GTK-Theme) không nằm trong repo.
  Cần `sassc` và `gtk-murrine-engine`, rồi dựng và liên kết cho libadwaita:
  `./themes/install.sh -c dark -n Tokyonight --tweaks black -l -d ~/.themes`
  Màu nhấn đổi sang `#7aa2f7`: sửa `$accent-dark` trong `themes/src/sass/_color-palette-default.scss` trước khi dựng.
  (`-l` tạo symlink `~/.config/gtk-4.0/{gtk.css,gtk-dark.css,assets}`).
  `gtk/.config/environment.d/theme.conf` đặt `GTK_THEME=Tokyonight-Dark`; biến này ghi đè gsettings,
  nên khi đổi theme GTK phải sửa cả ở đây rồi đăng nhập lại.
- **foot dùng nền đặc** (`alpha=1.0`): nền trong suốt làm foot tắt khử răng cưa subpixel, chữ mờ hơn trên màn mật độ thấp.

- **zsh và fcitx5 dùng `--no-folding`.** Nếu không, stow có thể symlink cả `~/.oh-my-zsh` hoặc `~/.local`
  vào repo, và oh-my-zsh, plugin zsh hay file trong `~/.local/bin` sẽ bị ghi vào cây repo.
  `bootstrap.sh` dừng lại nếu thấy `~/.oh-my-zsh` là symlink.
- **nvim thì để stow gộp thư mục** (`~/.config/nvim` là symlink vào repo), nên `nvim-pack-lock.json`
  do nvim cập nhật sẽ nằm ngay trong repo. Nhớ commit khi bạn nâng cấp plugin.
- **Plugin không nằm trong repo.** Plugin zsh và tmux (tpm) do `bootstrap.sh` clone; plugin nvim do `vim.pack` cài.
  Phiên bản plugin nvim được khoá trong `nvim/.config/nvim/nvim-pack-lock.json`.
- **Ảnh nền** dùng `/usr/share/backgrounds/default-dark.jxl` của Fedora (sway, swaylock, SDDM), không lưu trong repo.
  Đây là symlink tự trỏ sang ảnh của bản Fedora mới khi nâng cấp.
- **lazygit và Nerd Font** nằm trong repo [Terra](https://terra.fyralabs.com/) (gói `golang-github-jesseduffield-lazygit`,
  `jetbrainsmono-nerd-fonts` cho foot, `noto-nerd-fonts` cho waybar), cần bật repo này trước khi `dnf install`.
- **Bộ gõ tiếng Việt:** máy hiện dùng `fcitx5-lotus`, chưa được `bootstrap.sh` cài; cài riêng theo hướng dẫn của dự án đó.
- `sway/config.d/90-swayidle.conf` chỉ chứa comment, cố ý, để ghi đè file cùng tên của hệ thống.
- Không đưa `~/.config/gh` vào repo: `hosts.yml` chứa token đăng nhập.
