#!/bin/bash
# Must have run these on a new install
#sudo dnf install -y docker git
#sudo 
#sudo systemctl start docker
#sudo systemctl enable docker

echo "Will build the whole thing, it may take a long time as well as ~10GB space"

#sudo docker build --rm -t $USER/silverblazerepo .
#sudo docker run --privileged -d -p 8000:8000 --name silverblazerepo $USER/silverblazerepo

cd /srv/repo
echo "Initialize a new empty repository in /srv/repo/ directory in archive mode"
ostree --repo=repo init --mode=archive-z2

echo "Cloning fedora-atomic repository config"
cd /srv
git clone https://pagure.io/workstation-ostree-config.git
cd /srv/workstation-ostree-config
git checkout f30

cd /srv
echo "Creating a local repo file in /etc for custom rpm"
createrepo /srv/local-repo/
echo "[local-repo]
name=ostree local-testing
baseurl=/srv/local-repo/
enabled=1
gpgcheck=0
metadata_expire=1d" > /etc/yum.repos.d/local-repo.repo

echo "Creating the build repo for ostree"
cd /srv/build-repo
ostree --repo=/srv/build-repo init --mode=bare-user

# Get packages
# Get ZFS
cd /srv/packages
echo "Cloing ZFS and building it"
git clone https://github.com/zfsonlinux/zfs
cd zfs
git checkout master
sh autogen.sh
./configure
make 
make -s -j$(nproc)
make -j$(nproc) rpm
cp *.rpm /srv/local-repo

# Get Bcachefs
# echo "Cloning in bcachefs"
# ce /srv/packages
#RUN git clone https://evilpiepirate.org/git/bcachefs.git
#RUN git clone https://evilpiepirate.org/git/bcachefs-tools.git
#RUN dnf install libzstd-devel libzstd lz4-devel lz4-libs libsodium-devel libsodium userspace-rcu userspace-rcu-devel libaio libaio-devel libscrypt-devel libscrypt bc

echo "Creating or updating local-repo"
createrepo /srv/local-repo/

# ADD TEST IF ZFS IS INCLUDED
dnf clean all
dnf search zfs --refresh
#dnf update -y # Update to be sure that no packaged changed while building this (it happened once ! and it was kernel, need to rebuild it since ostree will fetch non-matching kernel with zfs ...)

# TODO 
# Make it so that installation kernel match zfs kernel...

echo "entering in workstation-ostree-config for rpm-ostree compose
cd /srv/workstation-ostree-config
curl https://raw.githubusercontent.com/johnr14/silverblaze/master/fedora-silverblaze.yaml > fedora-silverblaze.yaml
rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblaze.yaml

echo "Pulling silverblaze in repo"
ostree --repo=/srv/repo pull-local /srv/build-repo fedora/30/x86_64/silverblaze

echo "All done"
