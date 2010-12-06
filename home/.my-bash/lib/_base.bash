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
