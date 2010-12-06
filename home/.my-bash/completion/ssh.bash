#!/bin/bash
# Bash completion support for ssh.

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_sshcomplete() {
    if [ -f $HOME/.ssh/config ]; then
        COMPREPLY=($(compgen -W "`grep '^Host' $HOME/.ssh/config | sed 's/^Host //' | sort | uniq`" -- ${COMP_WORDS[COMP_CWORD]}))
        return 0
    fi
}

complete -o default -o nospace -F _sshcomplete ssh
