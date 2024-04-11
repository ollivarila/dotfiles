# Open vscode from current directory
alias vsc='code .'
# Kubectl
alias k="kubectl"
alias m="minikube"

alias ls="exa"
alias la="exa -la"

# pnpm i -D @types/<package>
alias types='_t() { pnpm i -D "@types/$1" }; noglob _t'

# git clone git@github.com:ollivarila/<repo>.git
alias clone='_cl() { git clone git@github.com:ollivarila/$1.git }; noglob _cl'

alias dcu='docker compose up -d'
alias dcd='docker compose down'
