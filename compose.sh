#!/bin/bash
# FIX THIS
#sudo dnf install docker
#sudo systemctl start docker

echo "Will build the whole thing, it may take a long time as well as ~10GB space"

sudo docker build --rm -t $USER/silverblazerepo .
sudo docker run --privileged -d -p 8000:8000 --name silverblazerepo $USER/silverblazerepo

echo " run : 
sudo docker exec -it silverblazerepo bash
cd /srv/workstation-ostree-config
# A default silverblue ostree :

# Compose the tree with :
rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblue.yaml 
# Pull repo once commit is done
ostree --repo=/srv/repo pull-local /srv/build-repo fedora/30/x86_64/silverblue

# A custom silverblaze ostree :
curl https://raw.githubusercontent.com/johnr14/silverblaze/master/fedora-silverblaze.yaml > fedora-silverblaze.yaml
rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblaze.yaml
ostree --repo=/srv/repo pull-local /srv/build-repo fedora/30/x86_64/silverblaze

# Try it on a running sliverblue ??
"
