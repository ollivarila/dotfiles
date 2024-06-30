# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Artisanal zsh config

# Dir for plugins
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

setup_zinit () {
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}

# Init plugin manager if not setup
[ ! -d $ZINIT_HOME ] && setup_zinit

# Load plugin manager
source "${ZINIT_HOME}/zinit.zsh"

path () {
  export PATH=$PATH:"$1"
}

path "$HOME/.local/share/bob/nvim-bin"
path "$HOME/.cargo/bin"
path "$HOME/.bin"
path "/opt/homebrew/opt/postgresql@13/bin"

export EDITOR="nvim"

. "$HOME/.cargo/env"

# Plugins

# Shell prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Syntax highlights
zinit light zsh-users/zsh-syntax-highlighting

# Shell completion
zinit light zsh-users/zsh-completions

# Autoload completions
autoload -U compinit && compinit

zinit cdreplay -p

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Fzf tab completion
zinit light Aloxaf/fzf-tab

# OMZ plugins
zinit snippet OMZP::git
zinit snippet OMZP::z
zinit snippet OMZP::colored-man-pages

# Some useful keybinds
bindkey -e
bindkey '^ ' autosuggest-accept 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Options

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion*' menu no

# Aliases
alias cat='bat'
alias ls='exa'
alias la='exa -la'
alias y='yarn'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias v='nvim'
alias olli='export AWS_PROFILE=olli'

# Source work config
[ $(whoami) = 'olli.varila' ] && source "$HOME/.work.zsh"

# Ffz shell integration
eval "$(fzf --zsh)"

export NVM_DIR="$HOME/.nvm"

[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

path "$(yarn global bin)"

git_current_branch () {
  git rev-parse --abbrev-ref HEAD
}

export BAT_THEME="gruvbox-dark"
