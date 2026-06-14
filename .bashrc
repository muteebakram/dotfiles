# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

_setup_distro_prompt() {
    local id
    DISTRO_ICON=
    DISTRO_COLOR='\[\033[01;32m\]'  # default green

    [[ -r /etc/os-release ]] || return 0
    # shellcheck disable=SC1091
    . /etc/os-release
    id=$(printf '%s' "${ID:-}" | tr '[:upper:]' '[:lower:]')

    case "$id" in
        debian|raspbian)
            DISTRO_ICON=$'\uf306'  # logos-debian
            DISTRO_COLOR='\[\033[38;5;167m\]'  # debian red
            ;;
        ubuntu|pop|linuxmint)
            DISTRO_ICON=$'\uf31c'  # logos-ubuntu
            DISTRO_COLOR='\[\033[38;5;166m\]'  # ubuntu orange
            ;;
        arch|manjaro|endeavouros)
            DISTRO_ICON=$'\uf303'  # logos-archlinux
            DISTRO_COLOR='\[\033[38;5;39m\]'   # arch blue
            ;;
        fedora|centos|rocky|redhat)
            DISTRO_ICON=$'\uf30a'  # logos-fedora
            DISTRO_COLOR='\[\033[38;5;25m\]'   # fedora blue
            ;;
    esac
}

_setup_distro_prompt

_git_prompt_part() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

    local branch stats
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    [[ -n "${branch}" ]] || branch=$(git rev-parse --short HEAD 2>/dev/null)

    stats=$(git --no-pager status --porcelain=v1 2>/dev/null | awk '
  /^\?\?/ {a++; next}
  {
    x=substr($0,1,1); y=substr($0,2,1)
    if (x=="A" || y=="A") a++
    else if (x=="D" || y=="D") d++
    else if (x=="M" || y=="M" || x=="R" || y=="R" || x=="C" || y=="C" || x=="T" || y=="T") m++
  }
  END {
    sep=""
    if (a) {printf "%s+%d", sep, a; sep=" "}
    if (d) {printf "%s-%d", sep, d; sep=" "}
    if (m) {printf "%s±%d", sep, m; sep=" "}
  }')

    printf '%s' "󰊢 ${branch}${stats:+ ${stats}}"
}

_update_prompt_git() {
    GIT_PROMPT=$(_git_prompt_part)
}

PROMPT_COMMAND="_update_prompt_git${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
_update_prompt_git

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] '"${DISTRO_COLOR}"'${DISTRO_ICON:+$DISTRO_ICON }\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]${GIT_PROMPT:+ \[\033[36m\]${GIT_PROMPT}\[\033[0m\]}\[\033[38;5;28m\] →\[\033[0m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u ${DISTRO_ICON:+$DISTRO_ICON }\h \W${GIT_PROMPT:+ ${GIT_PROMPT}} → '
fi

unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u \h  \w\a\]"$PS1' '
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Start tmux if not already
if [[ "${TMUX}" == "" ]]; then
  if tmux has-session 2>/dev/null; then
    echo "Attaching tmux ${TMUX}"
    tmux a;
  else
    echo "Starting tmux..."
    tmux
  fi
fi
