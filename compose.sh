#!/bin/bash
# FIX THIS
#sudo dnf install docker
#sudo systemctl start docker
#sudo systemctl enable docker

echo "Will build the whole thing, it may take a long time as well as ~10GB space"

sudo docker build --rm -t $USER/silverblazerepo .
sudo docker run --privileged -d -p 8000:8000 --name silverblazerepo $USER/silverblazerepo

echo " run : 
sudo docker exec -it silverblazerepo bash

# Build ZFS
cd /srv/packages/zfs
git checkout master
sh autogen.sh
./configure
#./configure --with-linux=../bcachefs to build with same kernel as bcachefs. The kernel must be build before.
make -s -j$(nproc)

# Build bcachefs
git clone https://evilpiepirate.org/git/bcachefs.git
git clone https://evilpiepirate.org/git/bcachefs-tools.git


cd /srv/workstation-ostree-config
# A default silverblue ostree :
rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblue.yaml 
# Pull repo once commit is done
ostree --repo=/srv/repo pull-local /srv/build-repo fedora/30/x86_64/silverblue

# A custom silverblaze ostree :
curl https://raw.githubusercontent.com/johnr14/silverblaze/master/fedora-silverblaze.yaml > fedora-silverblaze.yaml
rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblaze.yaml
ostree --repo=/srv/repo pull-local /srv/build-repo fedora/30/x86_64/silverblaze

# Try it on a running sliverblue ??
sudo ostree remote add fedora-silverblaze http://192.168.122.143:8000/ --no-gpg-verify 
sudo rpm-ostree rebase fedora-silverblaze:fedora/30/x86_64/silverblue 
sudo systemctl reboot
"
