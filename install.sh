#!/bin/bash

RELATIVE_SHIM_LOCATION="scripts/command_shim.sh"
INSTALL_LOCATION="${HOME}/.easy_jupyter"

# Calculate absolute location of execution shim
absolute_shim_location=$INSTALL_LOCATION/$RELATIVE_SHIM_LOCATION

echo "Copying source..."

# Install all src into permanent home
mkdir -p $INSTALL_LOCATION/
cp -r src/* $INSTALL_LOCATION

# Initialize state
echo "Initializing state..."
AWS_STATE_LOCATION="$INSTALL_LOCATION/data/state_data/AWS_ACTIVE.dat"
if test -f $AWS_STATE_LOCATION; then
  echo "AWS state exists, not overwriting..."
else
  echo "AWS state does not exist, creating..."
  echo "false" >> $AWS_STATE_LOCATION
fi

echo "Configuring execution shim..."
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
  touch $install_location/data/state_data/$statefile
  echo "$2" > $install_location/data/state_data/$statefile
}

function easy-jupyter () {
  local EASY_JUPYTER_PATH=$install_location
  eval source $install_location/data/constants
  eval source $install_location/commands/$1
}
EOF

echo "Modifying bash profile..."
# Only add the shim to the profile if it doesn't exist already.
grep -qxF "source $absolute_shim_location" ~/.bash_profile || echo "source $absolute_shim_location" >> ~/.bash_profile

echo "Done install. Run  'source ~/.bash_profile' in all open terminal windows."
