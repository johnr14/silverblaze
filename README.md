
# Silverblaze ostree
The objectif is to generate a ostree image of a custom silverblue installation.
Silverblaze is to be a Fedora OS based on a immutable ostree root that will try out bleeding edge packages and agressive optimization. If it crash or makes problems, just revert to a regular ostree.

##Ideology :
A) Bundle all usefull console and window manager application in the ostree.
B) Use flatpack for any optional GUI application.
C) Sync a /var/home on cloud to syncronyse all computers/VMs

## Steps
1) Generate a bootable silverblue ostree.
2) Generate a custom silverblue ostree.
3) Generate a silverblaze ostree that has same packages that the custom-silverblue
4) Build a custom kernel and bundle it in the ostree image.
5) Patch kernel and make it still work.
	- clear linux optimizations
	- wireguard
	- bcachefs
6) Build custom rpm packages with Clear Linux optimizations.
	- need a gpg key ?
7) Compress binaries with UPX in a silverblaze-upx ostree for testing
	- Any benefits ?
8) Bundle phoronix benchmarking to test performance gains
9) Custom flatpack with optimizations.
10) Run as main OS :)

# IMPORTANT
This is a personal project and may not come to be completed soon. 
Send issue if you use/fork/ameliorate/have similar to let me know.
Fedora may use the name Silverblaze if they wish to promote an optimized version of Silverblue.

# NOTES
I have errors building the ostree in a container as it tries to look for systemd and pid 1 is the python simplehttpd.
Also rpm database gets often corrupted for no reason while running in docker...
I will run it in a VM and try if I have better chances.

## Rebase a silverblue to custom ostree
sudo ostree remote add fedora-silverblaze http://192.168.122.143:8000/ --no-gpg-verify
sudo rpm-ostree rebase fedora-silverblaze:fedora/30/x86_64/silverblue
sudo systemctl reboot

## ZFS
Pull ZFS

cd /srv
mkdir packages && cd packages
git clone https://github.com/zfsonlinux/zfs.git

#INSTALL DEPENDANCIES
sudo dnf groupinstall "C Development Tools and Libraries"
sudo dnf install zlib-devel libuuid-devel libattr-devel libblkid-devel libselinux-devel libudev-devel
sudo dnf install parted lsscsi ksh openssl-devel elfutils-libelf-devel libtirpc-devel
sudo dnf install kernel-devel-$(uname -r)


## Create an ISO
http://www.projectatomic.io/docs/fedora_atomic_bare_metal_installation/


### List of custom applications 
htop
screen
dhc
xclip
net-tools
tuptime
neofetch
expect
lsof
colordiff
git
etckeeper
dar
p7zip-full
p7zip-rar
curl
aria2



### List of flatpacks
vlc
handbrake
gimp
digicam

