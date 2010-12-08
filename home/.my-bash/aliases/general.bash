#! /bin/bash

# List directory contents
alias sl=ls
alias ls='ls -G'        # Compact view, show colors
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -al'
alias l='ls -a'
alias l1='ls -1'

if [ $(uname) = "Linux" ]
then
  alias ls="ls --color=always"
fi

alias c='clear'
alias k='clear'

alias edit="$EDITOR"
alias page="$PAGER"

alias q="exit"

alias ..='cd ..'        # Go up one directory
alias ...='cd ../..'    # Go up two directories
alias -- -="cd -"       # Go back

# Shell History
alias h='history'

# Tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Directory
alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v'
