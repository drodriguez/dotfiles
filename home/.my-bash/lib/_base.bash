#! /bin/bash

# Editor
export EDITOR="/usr/bin/nano -w"
export GIT_EDITOR="/usr/bin/nano -w"

# Pager
export PAGER=most

# Don't check mail on login
unset MAILCHECK

# colored grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;33'

# colored ls
export LSCOLORS='Gxfxcxdxdxegedabagacad'

export LD_LIBRARY_PATH=/usr/local/lib/
export MAN_PATH=$MAN_PATH:/usr/local/share/man/

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize