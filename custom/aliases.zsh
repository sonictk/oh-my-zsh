# Custom user aliases go here

# System aliases
function trash() { mv $@ /home/$USER/.local/share/Trash/files; }

# Git aliases
alias git ls-files | xargs cat | wc -l
alias gl=git log --oneline --all --graph --decorate $*

## Application aliases
alias kill_maya="pkill maya"
alias kill_mari="pkill MriBin"
