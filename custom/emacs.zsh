# Prevents Emacs terminal from showing garbage character data
if [[ $TERM = dumb ]]; then
  unset zle_bracketed_paste
fi

# Emacs lightweight C++ config
alias lwemacs="emacs -q --load ~/Git/lightweight-emacs/lightweight_config.el"
