# Custom user aliases go here

# Git aliases
alias git ls-files | xargs cat | wc -l
alias gl=git log --oneline --all --graph --decorate $*

# Blizzard aliases

## Application aliases
alias kill_maya="pkill maya"
alias kill_mari="pkill MriBin"

alias charm="/home/yliangsiew/Applications/pycharm-community-2016.1/bin/pycharm.sh"
alias pycharm5="/home/yliangsiew/Applications/pycharm-community-2016.1/bin/pycharm.sh"

alias sublimetext="/home/yliangsiew/Applications/sublime_text_3/sublime_text"

alias qmake="/usr/lib64/qt4/bin/qmake $*"
alias npm="/home/yliangsiew/Downloads/node-v5.9.1-linux-x64/bin/npm"

## Build aliases
alias buildpackage='bl -p=build blpkgpub -d -f 1 -z 0 -o "/corp.blizzard.net/BFD/Farm/Public/$USER/packages" $*'
alias updatepipeline="bl -p=build blpipeup $*"
