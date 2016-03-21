# Custom user aliases go here

# Git aliases
alias git ls-files | xargs cat | wc -l
alias gl=git log --oneline --all --graph --decorate $*

# Blizzard aliases

## Application aliases
alias kill_maya="pkill maya"
alias charm="/home/yliangsiew/Applications/pycharm-community-5.0.4/bin/pycharm.sh"
alias pycharm5="/home/yliangsiew/Applications/pycharm-community-5.0.4/bin/pycharm.sh"
alias qmake="/usr/lib64/qt4/bin/qmake $*"

## Build aliases
alias buildp='bl -p=build blpkgpub -d -f 1 -z 0 -o "/corp.blizzard.net/BFD/Farm/Public/$USER/packages" $*'
