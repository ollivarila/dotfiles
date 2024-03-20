PROMPT=" %{$fg[blue]%}%C%{$reset_color%} "
PROMPT+='$(git_prompt_info)'
PROMPT+="%(?:%{$fg_bold[magenta]%}$:%{$fg_bold[red]%}$)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$fg_bold[magenta]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[magenta]%})"
