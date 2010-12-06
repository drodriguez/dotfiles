#!/bin/bash

# For generic functions.

function ips {
  ifconfig | grep "inet " | awk '{ print $2 }'
}

function myip {
  res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
  echo "Your public IP is: ${bold_green} $res ${normal}"
}

function mkcd {
  mkdir -p "$*"
  cd "$*"
}

pcurl() {
  curl "${1}" | open -f -a $PREVIEW
}

quiet() {
	$* &> /dev/null &
}

# disk usage per directory
# in Mac OS X and Linux
usage ()
{
    if [ $(uname) = "Darwin" ]; then
        if [ -n $1 ]; then
            du -hd $1
        else
            du -hd 1
        fi

    elif [ $(uname) = "Linux" ]; then
        if [ -n $1 ]; then
            du -h --max-depth=1 $1
        else
            du -h --max-depth=1
        fi
    fi
}
