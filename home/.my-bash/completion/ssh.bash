#!/bin/bash
# Bash completion support for ssh.

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_sshcomplete() {
    COMPREPLY=()
    comp_ssh_hosts=`cat $HOME/.ssh/known_hosts | \
        cut -f 1 -d ' ' | \
        sed -e s/,.*//g | \
        grep -v ^# | \
        uniq | \
        grep -v "\[" ;
        if [ -f $HOME/.ssh/config ]; then
            cat $HOME/.ssh/config | \
                grep "^Host " | \
                awk '{print $2}'
        fi
        `
    COMPREPLY=($(compgen -W "${comp_ssh_hosts}" -- ${COMP_WORDS[COMP_CWORD]}))
    return 0
}

complete -o default -o nospace -F _sshcomplete ssh
