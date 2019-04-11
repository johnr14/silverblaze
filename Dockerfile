FROM fedora:30

# make sure we have fast downloads
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

# Update, install specified packages and clean cached information
RUN dnf update -y && dnf install -y git python rpm-ostree ostree-grub2 ostree zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel parted lsscsi ksh openssl-devel elfutils-libelf-devel libtirpc-devel kernel-devel-$(uname -r) fedora-packager fedora-review libffi-devel python3-devel libaio-devel; dnf groupinstall "C Development Tools and Libraries" -y; dnf clean all

# Create specified directories
RUN mkdir -p /srv /srv/repo /srv/cache /srv/build-repo /srv/packages /srv/local-repo

# SEE https://rpm-ostree.readthedocs.io/en/latest/manual/compose-server/

# Expose default SimpleHTTPServer port and start SimpleHTTPServer
WORKDIR /srv/repo
EXPOSE 8000
CMD python -m SimpleHTTPServer
