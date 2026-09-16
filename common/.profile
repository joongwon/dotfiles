export LANG=en_US.UTF-8

export EDITOR=vim
export PATH=$HOME/.local/bin:$PATH

export BAT_THEME=gruvbox-light

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
