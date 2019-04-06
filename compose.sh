#!/bin/bash
# FIX THIS
#sudo dnf install docker
#sudo systemctl start docker

echo "Will build the whole thing, it may take a long time as well as ~10GB space"

sudo docker build --rm -t $USER/silverblazerepo .
sudo docker run --privileged -d -p 8000:8000 --name silverblazerepo $USER/silverblazerepo

echo " run : 
sudo docker exec -it silverblazerepo bash"
