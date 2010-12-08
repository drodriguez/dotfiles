#! /bin/bash

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PROMPT"
    ;;
*)
    ;;
esac
