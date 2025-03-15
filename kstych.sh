#!/bin/bash

ARG1=${1:-localhost}
ARG2=${2:-localhost}
ARG3=${3:-127.0.0.1}

mkdir -p data/custom
mkdir -p data/var/lib/mysql
mkdir -p data/etc/letsencrypt
chmod -R 777 data

echo "Running Kstych/Framework"

COMMAND="podman"
if ! command -v $COMMAND &> /dev/null
then
    COMMAND="docker"
fi

$COMMAND network create -d bridge kstych-framework > /dev/null 2>&1
$COMMAND container rm kstych-framework  > /dev/null 2>&1

$COMMAND run --rm -it --shm-size=2gb \
                --network=kstych-framework \
                --pids-limit 10000 \
                --name=kstych-framework \
                -v `pwd`/data/var/lib/mysql:/var/lib/mysql:Z \
                -v `pwd`/data/custom:/home/Kstych/Framework/custom:Z \
                -v `pwd`/data/etc/letsencrypt:/etc/letsencrypt:Z \
                -p 80:80 -p 443:443 \
                -e KSTYCH_LICENSE="$ARG1" -e KSTYCH_DOMAIN="$ARG2" -e KSTYCH_IP="$ARG3" \
      kstych/framework
