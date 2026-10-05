# .bashrc
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell

alias ls='ls'
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -la'
alias lt='ls -lart'

alias fmtcpp='if command -v clang-format >/dev/null; then find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) -print0 | xargs -0 clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"; else echo "Error: clang-format not found"; fi'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

export PS1='\[\e[38;5;141m\]\u@\h \[\e[38;5;75m\]\w \[\e[38;5;245m\]$ \[\e[0m\]'

if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi


