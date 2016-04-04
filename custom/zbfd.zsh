###################
# Support functions
###################

# Checks if a value is in an array
# usage: inarray "$needle" "${haystack[@]}"
# return: success (0) or failure (1)
inarray () {
    local hay needle=$1
    shift
    for hay; do
        [[ $hay == $needle ]] && return 0
    done
    return 1
}

# Functions to help manage paths
# usage: PATH [VAR] [after]
#   PATH: path to work with
#   VAR: variable to be modified (default: PATH)
#   after: append (default: prepend)
# examples:
#   pathmod ~/bin after
#   pathmod ~/python/lib PYTHONPATH

pathremove () {
    local PVAR=${2:-PATH}
    local P=(${!PVAR//:/ })
    P=(${P[@]%%$1})
    local IFS=:
    export ${2:-PATH}="${P[*]}"
}
pathmod () {
    local PVAR=${2:-PATH}
    [ "$3" = "after" ] && PVAR=$2
    pathremove $1 $PVAR
    if [ "$2" = 'after' -o "$3" = 'after' ]; then
        export $PVAR="${!PVAR:+${!PVAR}:}$1"
    else
        export $PVAR="$1${!PVAR:+:${!PVAR}}"
    fi
}

# Color-to-code converter
# usage: color [effect] [fg] [bg]
# example:
#   color bold red green  =>  \[\e[1;31;42m\]
color () {
    local CODES=
    local COLORS=( black red green yellow blue magenta cyan white )
    local EFFECTS=( nm normal bd bold ft faint it italic ul underline bk blink fb fastblink rv reverse iv invisible )
    
    [ -z "$1" ] && CODES=0
    
    # Parse arguments
    while (( "$#" )); do
        # Set foreground first then background
        inarray "$1" "${COLORS[@]}"
        if [ $? = 0 ]; then
            if [ -z "$FG" ]; then 
                FG=$1
            else
                if [ -z "$BG" ]; then
                    BG=$1
                else
                    error="Only two colors are supported. '$1'"
                fi
            fi
        else
            # If it's not a color, it must be an effect
            inarray "$1" "${EFFECTS[@]}"
            if [ $? = 0 ]; then
                EF="$1"
            else
                error="Color or effect '$1' not recognized."
            fi
        fi
        
        shift
    done
    
    # Error
    if [ -n "$error" ]; then
        echo $(color bold red)color: $error$(color)
        return 1
    fi
    
    # Effects
    case "$EF" in
        nm | normal)       CODES=("${CODES[@]}" 0) ;;
        bd | bold)         CODES=("${CODES[@]}" 1) ;;
        ft | faint)        CODES=("${CODES[@]}" 2) ;;
        it | italic)       CODES=("${CODES[@]}" 3) ;;
        ul | underline)    CODES=("${CODES[@]}" 4) ;;
        bl | blink)        CODES=("${CODES[@]}" 5) ;;
        fb | fastblink)    CODES=("${CODES[@]}" 6) ;;
        rv | reversevideo) CODES=("${CODES[@]}" 7) ;;
        iv | invisible)    CODES=("${CODES[@]}" 8) ;;
    esac
    
    # Foreground
    case "$FG" in
        black)   CODES=("${CODES[@]}" 30) ;;
        red)     CODES=("${CODES[@]}" 31) ;;
        green)   CODES=("${CODES[@]}" 32) ;;
        yellow)  CODES=("${CODES[@]}" 33) ;;
        blue)    CODES=("${CODES[@]}" 34) ;;
        magenta) CODES=("${CODES[@]}" 35) ;;
        cyan)    CODES=("${CODES[@]}" 36) ;;
        white)   CODES=("${CODES[@]}" 37) ;;
    esac
    
    # Background
    case "$BG" in
        black)   CODES=("${CODES[@]}" 40) ;;
        red)     CODES=("${CODES[@]}" 41) ;;
        green)   CODES=("${CODES[@]}" 42) ;;
        yellow)  CODES=("${CODES[@]}" 43) ;;
        blue)    CODES=("${CODES[@]}" 44) ;;
        magenta) CODES=("${CODES[@]}" 45) ;;
        cyan)    CODES=("${CODES[@]}" 46) ;;
        white)   CODES=("${CODES[@]}" 47) ;;
    esac
    
    # Echo the code(s)
    for (( i=0; i<${#CODES[@]}; i++ )); do
        out="${out:+$out;}${CODES[${i}]}"
    done
    echo -n "\[\e[${out}m\]"
}

# Generates a single-line command prompt with color
# usage: bfd_prompt [full]
bfd_prompt () {
    # If $1 is "full" then display the full working directory
    local PWD_STYLE="\W"
    [ "$1" = 'full' ] && PWD_STYLE="\w"
    
    # User color
    local USER_COLOR
    if [ $EUID = 0 ]; then
        USER_COLOR=$(color red)
    else
        USER_COLOR=$(color blue)
    fi  
    
    # Hostname color
    local HOST_COLOR
    case "$(hostname -s)" in
        *-lid)
            # Desktop
            HOST_COLOR=$(color blue)
            ;;  
        oc23*|OC23*|irv6*|IRV6*)
            # Farm (typically render)
            HOST_COLOR=$(color green)
            ;;  
        oc2*|OC2*|irv*|IRV*)
            # Other farm machines (ex. oc2ut01)
            HOST_COLOR=$(color white)
            ;;
        *)
            # Anything else
            HOST_COLOR=$(color red)
    esac
    
    # Return the prompt string
    # Example:
    #   19:02:00 [0] [rtomson@rtomson-lid:/corp.blizzard.net/BFD]$
    
    # Can the shell display colors?
    case "$TERM" in
        xterm*)
            # Full color support
            echo "$(color bold)$(color cyan)\t$(color black) \
\`RET=\$?; if [ \$RET -ne 0 ]; then echo [$(color red)\$RET$(color black)]\ ; fi\`\
[${USER_COLOR}\u$(color black)@${HOST_COLOR}\h$(color black):$(color yellow)${PWD_STYLE}$(color black)]$(color normal)\\$ "
            ;;
        linux)
            # Remote connection through OA; doesn't support bold.
            # Removed user@host (since you should know what OA you're on) and shortened the path
            echo "$(color cyan)\t \
$(color normal)[\`RET=\$?; if [ \$RET = 0 ]; then echo $(color green)\$RET; else echo $(color red)\$RET; fi\`$(color normal)]\
[$(color yellow)\W$(color normal)]\\$ "
            ;;
        *)
            # No colors
            echo "\t [\`echo \$?\`] [\u@\h:${PWD_STYLE}]\\$ "
            ;;
    esac
}


##############################
## Department wide environment
##############################
# Add Temporary environment paths
export TEMP=/tmp
export TMP=/tmp

# Ignore .svn during tab-completion
export FIGNORE=.svn

# Aliases
alias tq=/opt/pixar/tractor-blade/bin/tq

# Bash Specific configuration
if [[ -n "${BASH_VERSION:-}" ]]; then
    shopt -s histappend
    
    # Bash history
    HISTCONTROL='erasedups:ignoreboth'
    HISTFILESIZE=100000
    HISTSIZE=50000
    # Append on exit instead of overwrite
    # Disable ^C from being printed on aborted commands
    # Make sure we only run stty in an interactive shell
    if [[ $- == *i* ]]; then
        stty -ctlecho
    fi
    
    ## Global environment (these are for any user, root included)
    # Better shell debugging (/bin/bash -x)
    PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}:} '
    
    
    ## Cinematics only environment
    # gid 10000 is Cinematics
    $(id -G | grep -q "\<10000\>")
    if [ $? = 0 ]; then
        # Grab the users full name
        export FULLNAME=$(getent passwd | awk -F: '$1 == ENVIRON["USER"] { print $5 }')
        
        # Enforce default permissions
        umask 002
        
        # Set the prompt
        PS1=`bfd_prompt`
        
        ## Aliases ##
        alias fp='cd /corp.blizzard.net/BFD/Farm/Public/$(id -nu)'
        alias ll='ls -lah --color=auto'
        
        ## Paths ##
        # bfdlaunch
        pathmod /corp.blizzard.net/BFD/Deploy/bfdlaunch PATH after
    
        # This function sets up the "setcontext" tool and shell environment.
        sc_setup() {
            local pipeline=setcontext
            if [ ! -z "$1" ]; then
                pipeline=$1
            fi 
            eval "$(bl --quiet -lc=0 -p=$pipeline sc_setup_tool)"
        }
        # Execute the default setcontext setup.
        if [ -z "$BFD_NO_SETCONTEXT" ] || [ "$BFD_NO_SETCONTEXT" != 1 ]; then
            sc_setup
        fi
    fi

 
    ## Engineering (or root) only environment
    # gid 10001 is Engineering
    $(id -G | grep -q '\<10001\>')
    if [ $? = 0 -o $EUID = 0 ]; then
        # Use the expanded long prompt style
        PS1=`bfd_prompt full`
        
        ## Aliases ##
        alias ll='ls -lah --color=auto'
        alias mnt='mount -t nfs -o tcp,rsize=65536,wsize=65536'
        alias shmux2='shmux -Bmt -M 16 -P 10 -c'
        alias ssh2='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null'
        alias vl='cd /var/log'
        
        ## Paths ##
        pathmod /corp.blizzard.net/BFD/unixAdmin/scripts/bin PATH after
        pathmod /corp.blizzard.net/BFD/Deploy/bfdlaunch PATH after
        pathmod /corp.blizzard.net/BFD/unixAdmin/Python PYTHONPATH
    fi
elif [[ -n "${ZSH_VERSION:-}" ]]; then
    emulate -L zsh
    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=1000
    setopt appendhistory autocd extendedglob histignoredups prompt_subst
    bindkey -e
    # End of lines configured by zsh-newuser-install
    # The following lines were added by compinstall
    zstyle :compinstall filename '$HOME/.zshrc'
    
    autoload -Uz compinit
    compinit
    autoload -U colors && colors
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    # End of lines added by compinstall
	function __bfd_prompt {
    	# Clock portion
        echo -n "%{$fg_bold[cyan]%}%* "
        # Return the error code if we have one, otherwise skip it
        echo -n "%(?..$fg_bold[black][%{%(?.$fg_bold[green].$fg_bold[red])%}%?%{$fg_bold[black]%}] )"
        # Username, color it red if we're root, blue otherwise
        echo -n "%{$fg_bold[black]%}[%{%(!.$fg_bold[red].$fg_bold[blue])%}%n%{$fg_bold[black]%}@"
        # Hostname, 
        local HOST_COLOR
        case "$(hostname -s)" in
            *-lid)
                # Desktop
                HOST_COLOR="%{$fg_bold[blue]%}"
                ;;  
            OC21B*|OC21C-2*|OC21C-3*|OC21C-4*|OC21D*|OC23*|OC25*)
                # Farm (typically render)
                HOST_COLOR="%{$fg_bold[green]%}"
                ;;  
            oc2*|OC2*)
                # Other farm machines (ex. oc2ut01)
                HOST_COLOR="%{$fg_bold[white]%}"
                ;;
            *)
                # Anything else
                HOST_COLOR="%{$fg_bold[white]%}"
        esac    
        echo -n "$HOST_COLOR%m%{$fg_bold[black]%}"
        # Path portion
        echo -n ":%{$fg_bold[yellow]%}%5~%{$fg_bold[black]%}]%{$reset_color%}%# " 
        
        }
    ###
    # See if we can use colors.
    #PROMPT="%{$fg_bold[cyan]%}%* %(?..$fg_bold[black][%{%(?.$fg_bold[green].$fg_bold[red])%}%?%{$fg_bold[black]%}] )%{$fg_bold[black]%}%{$fg_bold[black]%}[%{%(!.$fg_bold[red].$fg_bold[blue])%}%n%{$fg_bold[black]%}@%{$fg_bold[blue]%}%m%{$fg_bold[black]%}:%{$fg_bold[yellow]%}%5~%{$fg_bold[black]%}]%{$reset_color%}%# " 
    PROMPT=`__bfd_prompt`
    
    ## Cinematics only environment
    # gid 10000 is Cinematics
    emulate -L zsh
    $(id -G | grep -q "\<10000\>")
    if [ $? = 0 ]; then
        # Grab the users full name
        export FULLNAME="$(getent passwd | awk -F: '$1 == ENVIRON["USER"] { print $5 }')"
        
        # Enforce default permissions
        umask 002
        
        ## Aliases ##
        alias fp='cd /corp.blizzard.net/BFD/Farm/Public/$(id -nu)'
        alias ll='ls -lah --color=auto'
        
        ## Paths ##
        # bfdlaunch
        pathmod /corp.blizzard.net/BFD/Deploy/bfdlaunch PATH after
    
        # This function sets up the "setcontext" tool and shell environment.
        sc_setup() {
            local pipeline=setcontext
            if [ ! -z "$1" ]; then
                pipeline=$1
            fi 
            eval "$(bl --quiet -lc=0 -p=$pipeline sc_setup_tool)"
        }
        # Execute the default setcontext setup.
        if [ -z "$BFD_NO_SETCONTEXT" ] || [ "$BFD_NO_SETCONTEXT" != 1 ]; then
            sc_setup
        fi
    fi
fi

# Clean up
unset pathremove pathmod
unset inarray color bfd_prompt

