# dotfiles

This repo now uses GNU Stow.

## Packages

- `sh`: shell files like `.zshrc`, `.profile`, and `.dircolors`
- `git`: `.gitconfig`
- `x11`: `.xprofile`
- `gui`: shared GUI and desktop config under `.config` and `.local`
- `neovim`: `~/.config/nvim`
- `classic-vim`: `~/.vim` and `~/.vimrc`
- `machine-jwahn-ropas`: `jwahn-ropas`-specific `Xresources` and Hyprland config
- `machine-freleefty-home`: `freleefty-home`-specific `Xresources`

`extras/` holds repo files that are not currently stowed.

## Usage

Install everything for the current machine:

```bash
./setup
```

Or stow packages manually:

```bash
stow -Rv -t "$HOME" sh git x11 gui neovim classic-vim
stow -Rv -t "$HOME" machine-jwahn-ropas
```
