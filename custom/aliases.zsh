# Custom user aliases go here

# System aliases
function trash() { mv $@ /home/$USER/.local/share/Trash/files; }

# Git aliases
alias git ls-files | xargs cat | wc -l
alias gl=git log --oneline --all --graph --decorate $*

# Blizzard aliases
alias goto_scripts="cd ~/svn/dev/Users/yliangsiew/scripts"
alias goto_pipelines="cd /corp.blizzard.net/BFD/Farm/Public/yliangsiew/pipelines"

## Application aliases
alias kill_maya="pkill maya"
alias kill_mari="pkill MriBin"

alias charm="/home/yliangsiew/Applications/pycharm-community-2016.1/bin/pycharm.sh"
alias pycharm5="/home/yliangsiew/Applications/pycharm-community-2016.1/bin/pycharm.sh"

alias sublimetext="/home/yliangsiew/Applications/sublime_text_3/sublime_text"

alias qmake="/usr/lib64/qt4/bin/qmake $*"
alias npm="/home/yliangsiew/bin/node-v5.9.1-linux-x64/bin/npm"

# alias firefox="/home/yliangsiew/bin/firefox/firefox" # Firefox 45 search bar is not working properly, need to fix it before attempting to re-enable this alias

## Build aliases
buildpackage() { bl -p=build blpkgpub -d -f -n "$1" "/corp.blizzard.net/BFD/Farm/Public/$USER/packages"; }
alias updatepipeline="bl -p=build blpipeup $*"
alias gitr="/home/yliangsiew/bin/node-v5.9.1-linux-x64/lib/node_modules/gitr/bin/gitr.js $*"

alias seewindows="xfreerdp -f -x l -a 32 -k en-us --composition --plugin cliprdr -d blizzard -u yliangsiew ylsiew-w7"

alias bl="export PYTHONNOUSERSITE=1; bl $*"

## Farm aliases
alias spool="/opt/pixar/tractor-blade/bin/tractor-spool --engine=bfdtractor:8080"
