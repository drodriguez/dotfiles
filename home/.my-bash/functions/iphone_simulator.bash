#! /bin/bash

function cdsim {
  IOS_SIMULATOR_DATA_DIR="$HOME/Library/Application Support/iPhone Simulator"
  if [ ! $# == 2 ]; then
    version=$(ls -d "$IOS_SIMULATOR_DATA_DIR"/[[:digit:]]* | tail -n 1)
  else
    version="$IOS_SIMULATOR_DATA_DIR"/$2
  fi
  cd "$(ls -d "$version/Applications"/*/"$1.app"/.. | head -n 1)"
}

