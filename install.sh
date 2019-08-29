#!/bin/bash

RELATIVE_SHIM_LOCATION="scripts/command_shim.sh"
INSTALL_LOCATION="${HOME}/.easy_jupyter"

# Calculate absolute location of execution shim
absolute_shim_location=$INSTALL_LOCATION/$RELATIVE_SHIM_LOCATION

# Install all src into permanent home
mkdir -p $INSTALL_LOCATION/
cp -r src/* $INSTALL_LOCATION

# Customize the execution shim and install into bahs profile
# First, write in the expanded install location.
echo "install_location=$INSTALL_LOCATION" >> $absolute_shim_location

# Second, write in the shim code without any expantion.
cat << 'EOF' >> $absolute_shim_location

function ej-read-state () {
  local  __resultvar=$1
  local  myresult=$(cat $install_location/data/state_data/$1.dat)
  eval $__resultvar="'$myresult'"
}

function ej-write-state () {
  local  __resultvar=$1
  local statefile="$1.dat"

  # update var value
  eval $__resultvar="'$2'"

  # write the state to file
  touch statefile
  echo "$2" > $install_location/data/state_data/$statefile
}

function easy-jupyter () {
  eval source $install_location/data/constants
  eval source $install_location/commands/$1
}
EOF

echo "source $absolute_shim_location" >> ~/.bash_profile

# Persist the install location
install_location_state_file=$INSTALL_LOCATION/data/state_data/EASY_JUPYTER_PATH.dat
touch $install_location_state_file
echo "$INSTALL_LOCATION" >> $install_location_state_file
