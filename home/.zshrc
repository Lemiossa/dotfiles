# só roda em shell interativo
[[ -o interactive ]] || return

# histórico
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# opções úteis
setopt AUTO_CD
setopt CORRECT
setopt SHARE_HISTORY

# cores
autoload -U colors && colors

# aliases 
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'

alias ..='cd ..'
alias ...='cd ../..'

alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias fmtcpp='if command -v clang-format >/dev/null; then find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) -print0 | xargs -0 clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"; else echo "Erro: clang-format não encontrado"; fi'

# git prompt
git_prompt() {
    if command -v git >/dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        if [[ -n "$branch" ]]; then
            local git_status=""
            git diff --quiet 2>/dev/null || git_status="*"
            git diff --cached --quiet 2>/dev/null || git_status="${git_status}+"
            echo "%F{yellow}($branch$git_status)%f"
        fi
    fi
}

# prompt 
set_prompt() {
    local EXIT_CODE=$?

    local COLOR_OK="%F{green}"
    local COLOR_ERR="%F{red}"
    local COLOR_PATH="%F{blue}"

    local STATUS_COLOR=$COLOR_OK
    [[ $EXIT_CODE -ne 0 ]] && STATUS_COLOR=$COLOR_ERR

    PROMPT="${STATUS_COLOR}${EXIT_CODE} ${COLOR_PATH}%~ $(git_prompt) %F{green}> %f"
}

precmd_functions+=(set_prompt)

# autocomplete
autoload -Uz compinit && compinit

# plugins leves
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# env
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
