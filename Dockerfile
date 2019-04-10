FROM fedora:30

# make sure we have fast downloads
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

# Update, install specified packages and clean cached information
RUN dnf update -y && dnf install -y git python rpm-ostree ostree-grub2; \
dnf groupinstall "C Development Tools and Libraries"; \
dnf install zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel \
parted lsscsi ksh openssl-devel elfutils-libelf-devel libtirpc-devel kernel-devel-$(uname -r) fedora-packager fedora-review libffi-devel python3-devel ;\
dnf clean all

# Create specified directories
RUN mkdir -p /srv /srv/repo /srv/cache /srv/build-repo /srv/packages /srv/local-repo

# Set /srv as working directory and clone fedora-atomic repository into it
WORKDIR /srv
#RUN git clone https://pagure.io/fedora-atomic.git
RUN git clone https://pagure.io/workstation-ostree-config.git

# Initialize a new empty repository in /srv/repo/ directory in archive mode
RUN ostree --repo=repo init --mode=archive-z2

WORKDIR /srv/workstation-ostree-config
RUN git checkout f30

# Creating a local repo to all our custom rpm
WORKDIR /srv/local-repo
RUN createrepo /srv/local-repo/
RUN echo "[local-testing]
name=ostree local-testing
baseurl=/srv/local-repo/
enabled=1
gpgcheck=0
metadata_expire=1d" > /etc/yum.repos.d/local-testing.repo




# SEE https://rpm-ostree.readthedocs.io/en/latest/manual/compose-server/

WORKDIR /srv/build-repo
RUN ostree --repo=/srv/build-repo init --mode=bare-user

# Get packages
# Get ZFS
WORKDIR /srv/packages
RUN git clone https://github.com/zfsonlinux/zfs
#git checkout master
#sh autogen.sh
#./configure
#make -s -j$(nproc) rpm

# Get Bcachefs
#RUN git clone https://evilpiepirate.org/git/bcachefs.git
#RUN git clone https://evilpiepirate.org/git/bcachefs-tools.git
#RUN dnf install libzstd-devel libzstd lz4-devel lz4-libs libsodium-devel libsodium userspace-rcu userspace-rcu-devel libaio libaio-devel libscrypt-devel libscrypt bc


WORKDIR /srv/workstation-ostree-config
#RUN rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblue.yaml 

# Pull repo once commit is done
#RUN ostree --repo=/srv/repo pull-local build-repo centos-atomic-host/7/x86_64/standard

# UPDATE LOCAL-REPO
RUN createrepo /srv/local-repo/

# Expose default SimpleHTTPServer port and start SimpleHTTPServer
WORKDIR /srv/repo
EXPOSE 8000
CMD python -m SimpleHTTPServer
