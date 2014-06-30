#! /bin/bash

PEBBLE_HOME=$HOME/pebble-dev

if [ -d $PEBBLE_HOME ]; then
  export PATH=$PATH:$PEBBLE_HOME/PebbleSDK-2.0.2/bin
fi
