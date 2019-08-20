read -r -d '' CODE << EOF
# Easy Jupyter Config
$(printf "\n\n")
EASY_JUPYTER_PATH="$PWD"
function easy-jupyter () {
eval source \$EASY_JUPYTER_PATH/scripts/\$1
}
EOF

echo "$CODE" >> ~/.bash_profile
