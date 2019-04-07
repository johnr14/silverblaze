FROM fedora:30

# make sure we have fast downloads
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

# Update, install specified packages and clean cached information
RUN dnf update -y && dnf install -y git python rpm-ostree ostree-grub2; \
dnf clean all

# Create specified directories
RUN mkdir -p /srv /srv/repo /srv/cache /srv/build-repo

# Set /srv as working directory and clone fedora-atomic repository into it
WORKDIR /srv
#RUN git clone https://pagure.io/fedora-atomic.git
RUN git clone https://pagure.io/workstation-ostree-config.git

# Initialize a new empty repository in /srv/repo/ directory in archive mode
RUN ostree --repo=repo init --mode=archive-z2

WORKDIR /srv/workstation-ostree-config
RUN git checkout f30

# SEE https://rpm-ostree.readthedocs.io/en/latest/manual/compose-server/

WORKDIR /srv/build-repo
RUN ostree --repo=/srv/build-repo init --mode=bare-user

WORKDIR /srv/workstation-ostree-config
#RUN rpm-ostree compose tree --cachedir=/srv/cache --repo=/srv/build-repo /srv/workstation-ostree-config/fedora-silverblue.yaml 

# Pull repo once commit is done
#RUN ostree --repo=/srv/repo pull-local build-repo centos-atomic-host/7/x86_64/standard

# Expose default SimpleHTTPServer port and start SimpleHTTPServer
WORKDIR /srv/repo
EXPOSE 8000
CMD python -m SimpleHTTPServer
