#! /bin/bash

function rails_command {
  local cmd=$1
  shift
  
  if [ -e script/rails ]; then
    script/rails $cmd "$@"
  else
    script/$cmd "$@"
  fi
}

function rs {
  rails_command server "$@"
}

function rc {
  rails_command console "$@"
}

function rgen {
  rails_command generate "$@"
}

function rr {
  rails_command runner "$@"
}

function rl {
    tail -f log/${1-${RAILS_ENV-development}}.log
}

# This is not a function, but...
alias rb='touch tmp/restart.txt'
