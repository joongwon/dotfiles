source ~/.profile
bindkey -v '^H' backward-delete-char
alias ls='ls --color=auto'
alias grep='grep --color=auto'

export PROMPT='%F{120}%n@%m:%F{219}%~ %f%# ';



# The following lines were added by compinstall
zstyle :compinstall filename '/home/jwahn/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
