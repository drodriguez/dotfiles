#!/bin/bash

# append to bash_history if Terminal.app quits
shopt -s histappend

# history handling
# Erase duplicates, ignore lines with spaces at start, ignore duplicates
export HISTCONTROL=ignoreboth:erasedups

# resize history size
export HISTSIZE=5000

export PROMPT_COMMAND='history -a'

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
