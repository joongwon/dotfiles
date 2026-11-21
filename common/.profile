export LANG=en_US.UTF-8

export EDITOR=vim
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

export BAT_THEME=gruvbox-dark

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/usr/local/texlive/2026/bin/universal-darwin:$PATH"
else
  export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
fi
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH"

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
