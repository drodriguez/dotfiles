#! /bin/bash

if [ $(uname) = 'Darwin' ]; then
  PATH=/Applications/Postgres.app/Contents/MacOS/bin:$PATH
fi
