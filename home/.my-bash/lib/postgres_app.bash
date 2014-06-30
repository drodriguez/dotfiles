#! /bin/bash

if [ $(uname) = 'Darwin' ]; then
  export PATH=/Applications/Postgres.app/Contents/MacOS/bin:$PATH
fi
