#! /bin/bash

if [ $(uname) = 'Darwin' ]; then
  export PATH=$PATH:/Applications/Postgres.app/Contents/MacOS/bin
fi
