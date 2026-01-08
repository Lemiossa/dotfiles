# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias fmtcpp='find . -type f -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i --style="{BasedOnStyle: LLVM, UseTab: Always, TabWidth: 4, IndentWidth: 4}"'
alias ls='ls --color=auto'
PS1='\033[1;34m\w\033[1;32m $ \033[0m'

colorscript -r 
