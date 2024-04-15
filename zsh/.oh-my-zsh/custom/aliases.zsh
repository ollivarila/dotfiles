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

# pnpm docs <package>
alias pd='_pd() { pnpm docs $1 }; noglob _pd'

# cargo doc -p <crate> --open
alias cdo='_cdo() { cargo doc -p $1 --open }; noglob _cdo'

# alias bat to cat
alias cat="bat"
