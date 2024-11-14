get_latest_node_version() {
    curl -s https://releases.quilibrium.com/release | grep -oP 'node-\K[0-9]+(\.[0-9]+){1,4}' | sort -V | tail -n 1
}

get_current_node_version() {
    basename `readlink ~/ceremonyclient/node/node-linux-amd64` | awk -F'-' '{print $2}' | head -n 1 | cut -d. -f1-4
}

latest=$(get_latest_node_version)
current=$(get_current_node_version)
echo $latest
echo $current

if [[ $latest == $current  ]];then
    echo "no update"
else
    echo "new version update: $latest"
    ~/quil/quil_update.sh $latest
fi
