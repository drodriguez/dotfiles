#! /bin/bash

function iphone_simulator_directory {
  local app dir

  if [ -z "$1" ]; then
    echo `pwd`
  else
    app=`ls -td "~/Library/Application Support/iPhone Simulator/User/Applications/*/$1.app"`
    dir=`dirname "$app"`
    echo "$dir/Documents"
  fi
}

function cdsim {
  cd "`cdsim-helper $1`"
}
