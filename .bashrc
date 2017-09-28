# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

prompt_git() {
    git branch &>/dev/null || return 1
    HEAD="$(git symbolic-ref HEAD 2>/dev/null)"
    BRANCH="${HEAD##*/}"
    [[ -n "$(git status 2>/dev/null | \
        \grep -F 'working directory clean')" ]] || STATUS="!"
    printf '(git:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_hg() {
    hg branch &>/dev/null || return 1
    BRANCH="$(hg branch 2>/dev/null)"
    [[ -n "$(hg status 2>/dev/null)" ]] && STATUS="!"
    printf '(hg:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_svn() {
    svn info &>/dev/null || return 1
    URL="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "URL" {print $2}')"
    ROOT="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "Repository Root" {print $2}')"
    BRANCH=${URL/$ROOT}
    BRANCH=${BRANCH#/}
    BRANCH=${BRANCH#branches/}
    BRANCH=${BRANCH%%/*}
    [[ -n "$(svn status 2>/dev/null)" ]] && STATUS="!"
    printf '(svn:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_vcs() {
    prompt_git || prompt_svn || prompt_hg
}
prompt_jobs() {
    [[ -n "$(jobs)" ]] && printf '{%d} ' $(jobs | sed -n '$=')
}




COLOR_DIM_WHITE='\[\e[2;37m\]'
ECOLOR_DIM_WHITE='\e[2;37m'
COLOR_DIM_GREEN='\[\e[2;32m\]'
COLOR_GREEN='\[\e[1;32m\]'
ECOLOR_GREEN='\e[1;32m'
COLOR_MAGENTA='\[\e[1;35m\]'
ECOLOR_MAGENTA='\e[1;35m'
COLOR_BLUE='\[\e[1;34m\]'
ECOLOR_BLUE='\e[1;34m'
COLOR_RED='\[\e[1;31m\]'
ECOLOR_RED='\e[1;31m'
COLOR_YELLOW='\[\e[1;33m\]'
ECOLOR_YELLOW='\e[1;33m'
COLOR_RESET='\[\e[0m\]'
ECOLOR_RESET='\e[0m'
prompt_on() {
  # set variable identifying the chroot you work in (used in the prompt below)
  if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
  fi

  # set a fancy prompt (non-color, unless we know we "want" color)
  case "$TERM" in
      xterm-color) color_prompt=yes;;
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

  if [ "$color_prompt" = yes ]; then
      PS1='${debian_chroot:+($debian_chroot)}'${COLOR_GREEN}'\u@\h'${COLOR_RESET}':'${COLOR_BLUE}'\w'${COLOR_RESET}
      echo -e ${ECOLOR_DIM_WHITE}
      figlet -f standard "KINGDOM"
      echo -e ${ECOLOR_RESET}
  else
      PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
  fi
  unset color_prompt force_color_prompt

  # If this is an xterm set the title to user@host:dir
  case "$TERM" in
  xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
  *)
      ;;
  esac

  PS1=${COLOR_DIM_WHITE}'$(prompt_jobs)'${COLOR_RESET}$PS1'$(prompt_vcs) '${COLOR_RED}'\$ '${COLOR_RESET}
}

prompt_off() {
    PS1='\$ '
}

prompt_on

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto --exclude-dir=.svn'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias up='cd ..'
alias dcc='sudo drush cc all'
alias xclipin='xclip -in -selection c'
alias vsp='vim -O'
alias gip=mygeoiplookup
mygeoiplookup() {
  curl "ipinfo.io/$1"
}
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ls='ls --color=auto --group-directories-first'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export GREP_OPTIONS="--exclude-dir=.svn"
export EDITOR=vim

#PS1='\[\e[31m\]\u\[\e[0m\]'
export PATH=$PATH:~/bin
