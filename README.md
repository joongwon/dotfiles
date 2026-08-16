# dotfiles

Files managed by `stow` &amp; system packages managed by `metapac`.

## Packages

- `common`: shared shell and editor config
- `Linux`, `Darwin`: OS-specific config such as desktop environment and system services
- `machine-<hostname>`: optional per-host overrides, used automatically when a matching directory exists

## Usage

Synchronize everything for the current machine:

```bash
./setup
```
