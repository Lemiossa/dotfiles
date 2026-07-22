# .bashrc
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell

alias ls='lsd'
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -la'
alias lt='ls -lart'

alias fmtcpp='if command -v clang-format >/dev/null; then find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) -print0 | xargs -0 clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"; else echo "Erro: clang-format não encontrado"; fi'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Modern CLI replacements (if installed)
if command -v bat >/dev/null 2>&1; then alias cat='bat'; fi
if command -v eza >/dev/null 2>&1; then
	alias ls='eza --color=auto --icons=auto'
	alias ll='eza -lh --icons=auto'
	alias la='eza -a --icons=auto'
	alias l='eza -la --icons=auto'
	alias lt='eza -lart --icons=auto'
	alias tree='eza --tree --icons=auto'
fi
if command -v fd >/dev/null 2>&1; then alias find='fd'; fi
if command -v rg >/dev/null 2>&1; then alias grep='rg'; fi
if command -v btm >/dev/null 2>&1; then
	alias top='btm'
	alias htop='btm'
fi
if command -v fastfetch >/dev/null 2>&1; then alias neofetch='fastfetch'; fi

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -15'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gpl='git pull'

__git_prompt() {
	if command -v git >/dev/null 2>&1; then
		local branch=$(git branch --show-current 2>/dev/null)
		if [ -n "$branch" ]; then
			local status=""
			git diff --quiet 2>/dev/null || status="*"
			git diff --cached --quiet 2>/dev/null || status="${status}+"
			if git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
				local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
				local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
				[ "$ahead" -gt 0 ] && status="${status}↑"
				[ "$behind" -gt 0 ] && status="${status}↓"
			fi
			echo -e " \033[38;2;198;120;221m($branch$status)\033[0m"
		fi
	fi
}

set_prompt() {
	local EXIT_CODE="$?"
	local PURPLE="\[\033[38;2;198;120;221m\]"
	local GRAY="\[\033[38;2;92;99;112m\]"
	local GREEN="\[\033[38;2;152;195;121m\]"
	local RED="\[\033[38;2;224;108;117m\]"
	local RESET="\[\033[0m\]"

	PS1="${GRAY}\w\$(__git_prompt) $([ $EXIT_CODE -eq 0 ] && echo "${GREEN}" || echo "${RED}")\$ ${RESET}"
}

PROMPT_COMMAND=set_prompt

__load_completion() {
	[ -f /etc/bash_completion ] && . /etc/bash_completion
	[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
	[ -f /usr/bash-completion/bash_completion ] && . /usr/bash-completion/bash_completion
}

__load_completion

if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

