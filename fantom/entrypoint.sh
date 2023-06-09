#!/bin/sh

# exit script on any error
set -e

# Set fantom Home Directory
FANTOM_HOME=/datadir

if [ -n "${SNAPSHOT_URL}" ] && [ ! -f "${FANTOM_HOME}/bootstrapped" ];
then
  echo "downloading snapshot from ${SNAPSHOT_URL}"
  wget --tries=0 -O - "${SNAPSHOT_URL}" | tar -xz --strip-components=1 -C ${FANTOM_HOME}/ && touch ${FANTOM_HOME}/bootstrapped
fi

if [ ! -f "$FANTOM_HOME/mainnet.g" ];
then
    cd $FANTOM_HOME
    echo "downloading launch genesis file"
    wget --quiet https://download.fantom.network/mainnet-5577-full-mpt.g
fi

opera \
    --genesis=/datadir/mainnet-5577-full-mpt.g \
    --port=5050 \
    --maxpeers=200 \
    --datadir=/datadir \
    --http \
    --http.addr=0.0.0.0 \
    --http.port=18545 \
    --http.corsdomain="*" \
    --http.vhosts="*" \
    --ws \
    --ws.addr=0.0.0.0 \
    --ws.port=18546 \
    --ws.origins="*" \
    --nousb \
    --db.preset pbl-1 \
    --tracenode \
    --http.api=eth,web3,net,ftm,trace