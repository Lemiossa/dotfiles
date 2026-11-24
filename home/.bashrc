#!/bin/bash

[[ $- != *i* ]] && return

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias fmtcpp='if command -v clang-format >/dev/null; then find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) -print0 | xargs -0 clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"; else echo "Error: clang-format not found"; fi'

export PS1='\[\e[38;5;141m\]\w \[\e[38;5;213m\]$ \[\e[0m\]'

if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi
