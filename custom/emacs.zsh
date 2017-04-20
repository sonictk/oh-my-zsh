# Prevents Emacs terminal from showing garbage character data
if [[ $TERM = dumb ]]; then
  unset zle_bracketed_paste
fi
