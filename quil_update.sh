# stop the service
echo "1. stopping the ceremonyclient service first..."
service ceremonyclient stop
echo "... ceremonyclient service stopped"
 
# setting release OS, arch and current version variables
echo "2. setting release OS, arch and current version variables..."
release_os="linux"
release_arch="amd64"
current_version="2.0.0.6"
echo "... \$release_os set to \"$release_os\" and \$release_arch set to \"$release_arch\" and \$current_version set to \"$current_version\""
 
# deleting node (binaries, dgst and sig) files and re-download the same (but latest) required node files in the node folder
echo "3. deleting node (binaries, dgst and sig) files and re-download the same (but latest) required node files in the node folder..."
cd ~/ceremonyclient/node
rm -rf node-*-$release_os-$release_arch*
echo "... deleted node (binaries, dgst and sig) files from node folder"
files=$(curl https://releases.quilibrium.com/release | grep $release_os-$release_arch)
for file in $files; do
    version=$(echo "$file" | cut -d '-' -f 2)
    if ! test -f "./$file"; then
        curl "https://releases.quilibrium.com/$file" > "$file"
        echo "... downloaded $file"
    fi
done
chmod +x ./node-$version-$release_os-$release_arch

rm -rf qclient*
echo "... deleted qclient (binaries, dgst and sig) files from node folder"
files=$(curl https://releases.quilibrium.com/qclient-release | grep $release_os-$release_arch)
for file in $files; do
    clientversion=$(echo "$file" | cut -d '-' -f 2)
    if ! test -f "./$file"; then
        curl "https://releases.quilibrium.com/$file" > "$file"
        echo "... downloaded $file"
    fi
done
chmod +x ./qclient-$clientversion-$release_os-$release_arch
echo "... download of required qclient files done"

rm -rf node-linux-amd64
ln -s node-$current_version-linux-amd64 node-linux-amd64
rm -rf qclient-linux-amd64
ln -s qclient-$clientversion-linux-amd64 qclient-linux-amd64 
 
# start the service again
echo "6. starting the service again..."
service ceremonyclient start
echo "... service started"