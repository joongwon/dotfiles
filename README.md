# dotfiles

This repo now uses GNU Stow.

## Packages

- `common`: shared shell, editor, X11, and desktop config
- `machine-<hostname>`: optional per-host overrides, used automatically when a matching directory exists

`extras/` holds repo files that are not currently stowed.

## Usage

Install everything for the current machine:

```bash
./setup
```

Or stow packages manually:

```bash
stow -Rv -t "$HOME" common
stow -Rv -t "$HOME" machine-"$(hostname)"
```
