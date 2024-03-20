# Open vscode from current directory
alias vsc='code .'
# List all files and folders that match filter in current directory
alias s='la | grep '
# Open bash in local docker container
alias dbash='f(){ docker exec -it "$@" bash; unset -f f; }; f'
# Kubectl
alias k="kubectl"
alias m="minikube"

alias ls="exa"

alias la="exa -la"
