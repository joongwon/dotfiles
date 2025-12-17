source ~/.profile
alias grep='grep --color=auto'

# The following lines were added by compinstall
# zstyle :compinstall filename '/home/jwahn/.zshrc'
# ...which is replaced by the following line to reflect the correct home directory
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
bindkey -v '^H' backward-delete-char
bindkey -v '^?' backward-delete-char
# End of lines configured by zsh-newuser-install

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

if [[ "$(uname)" == "Darwin" ]]; then
  function newls() {
      /opt/homebrew/bin/gls --color=always -C $@ | iconv -f utf-8-mac -t utf-8
  }
  alias oldls='/bin/ls'
  alias ls='newls'

  export PROMPT='%F{120}%n@%m:%F{219}$(print -P %~ | iconv -f utf-8-mac -t utf-8) %f%# ';
  setopt PROMPT_SUBST
else
  alias ls='ls --color=auto'
  export PROMPT='%F{120}%n@%m:%F{219}%~ %f%# ';
fi

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
