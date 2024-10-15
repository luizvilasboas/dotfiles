export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.raku/bin:$HOME/bin:/usr/local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export LANG="pt_BR.UTF-8"
export ARCHFLAGS="-arch x86_64"
export PATH="$HOME/go/bin:$PATH"
export WALLPAPER_PATH="$HOME/Imagens/Wallpapers"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

ZSH_THEME="half-life"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(git)

source "$ZSH/oh-my-zsh.sh"

alias gc="git commit --verbose --message"
alias gcm="git checkout $(git_main_branch)"
alias gcb="git checkout -b"
alias gm="git merge"
alias ga="git add"
alias gp="git push"

alias ls="ls --color=never -p"
alias la="ls -A"

alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."

# Created by `pipx` on 2024-08-01 17:26:54
export PATH="$PATH:/home/luiz/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
poetry config virtualenvs.in-project true

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/luiz/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/luiz/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/luiz/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/luiz/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(/home/luiz/.rakubrew/bin/rakubrew init Zsh)"
