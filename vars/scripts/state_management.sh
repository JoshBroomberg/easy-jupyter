#!/bin/bash

function ej-read-state () {
  local  __resultvar=$1
  local  myresult=`cat $EASY_JUPYTER_PATH/vars/state_data/$1.dat`
  eval $__resultvar="'$myresult'"
}

function ej-write-state () {
  local  __resultvar=$1
  local statefile="$1.dat"

  # update var value
  eval $__resultvar="'$2'"

  # write the state to file
  touch statefile
  echo "$2" > $EASY_JUPYTER_PATH/vars/state_data/$statefile
}
