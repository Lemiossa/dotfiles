# .bashrc
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'

alias fmtcpp='if command -v clang-format >/dev/null; then find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) -print0 | xargs -0 clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"; else echo "Erro: clang-format não encontrado"; fi'

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

__git_prompt() {
	if command -v git >/dev/null 2>&1; then
		local branch=$(git branch --show-current 2>/dev/null)
		if [ -n "$branch" ]; then
			local status=""
			if ! git diff --quiet 2>/dev/null; then
				status="*"
			fi
			if ! git diff --cached --quiet 2>/dev/null; then
				status="$status+"
			fi
			echo -e " \033[33m($branch$status)\033[0m"
		fi
	fi
}

set_prompt() {
	local EXIT_CODE="$?"
	local RED="\[\033[31m\]"
	local GREEN="\[\033[32m\]"
	local BLUE="\[\033[34m\]"
	local RESET="\[\033[0m\]"

	local STATUS_COLOR=$GREEN
	[ $EXIT_CODE -ne 0 ] && STATUS_COLOR=$RED

	PS1="${STATUS_COLOR}${EXIT_CODE} ${BLUE}\w\$(__git_prompt) \r\n${GREEN}> ${RESET}"
}

PROMPT_COMMAND=set_prompt

export PATH="/opt/cross/bin:$PATH"

colorscript -r

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
