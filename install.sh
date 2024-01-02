#!/bin/bash

case $1 in
    "arbitrum")
        # snapshot
        docker volume create arbitrum_classic-data
        curl https://snapshot.arbitrum.io/mainnet/db.tar | tar -xv -C  /var/lib/docker/volumes/arbitrum_classic-data/data
        ;;
    "avalanche")
        # config
        docker volume create avalanche_config
        cp avalanche/node.json /var/lib/docker/volumes/avalanche_config/_data/

        # C chain config
        docker volume create avalanche_c-config
        cp avalanche/config.json /var/lib/docker/volumes/avalanche_c-config/_data/
        ;;
    "optimism")
        ;;
    "celo")
        apt install libusb-1.0-0-dev libudev-dev
        npm install -g @celo/celocli
        ;;
    "fantom")
        ;;
    "ethereum")
        docker volume create ethereum_config
        cp ethereum/config.yaml /var/lib/docker/volumes/ethereum_config/_data/
        ;;
    "gnosis")
        docker volume create gnosis_config
        cp gnosis/config.yaml /var/lib/docker/volumes/gnosis_config/_data/
        ;;
    *)
        echo "Chain not supported yet!"
        exit
        ;;
esac


if [ -z "$2" ]; then
    COMPOSE_PROJECT_NAME=$1 COMPOSE_FILE=$1/$1.yml docker compose --env-file .env up -d --remove-orphans --build
else
    COMPOSE_PROJECT_NAME=$1 COMPOSE_FILE=$1/$1.yml docker compose --env-file .env.$2 up -d --remove-orphans --build
fi

# export to .bashrc if needed
if ! grep -q "#node-setup" ~/.bashrc; then
    echo "Modifying .bashrc ..."
    DIR="$( cd "$( dirname -- $0 )" && pwd )"
    echo -e "\n" >> ~/.bashrc
    echo "#node-setup" >> ~/.bashrc
    echo "export NODE_DIR=$DIR" >> ~/.bashrc
    echo 'source $NODE_DIR/utils/manage' >> ~/.bashrc
    source ~/.bashrc
fi