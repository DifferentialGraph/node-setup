#!/bin/bash
set -eu

ADDITIONAL_ARGS=""

if [ $OPSTACK_CHAIN == "base" ]; then
    BINARY="./base-reth-node"

    # Enable Flashblocks support if websocket URL is provided
    if [[ -n "${RETH_FLASHBOCKS:-}" ]]; then
        ADDITIONAL_ARGS="--websocket-url=wss://mainnet.flashblocks.base.org/ws"
    fi

    ADDITIONAL_ARGS="${ADDITIONAL_ARGS:-} --rollup.sequencer-http=https://mainnet-sequencer.base.org"
elif [ $OPSTACK_CHAIN == "optimism" ]; then
    # # Wait for the Bedrock flag for this network to be set.
    # echo "Waiting for Bedrock node to initialize..."
    # while [ ! -f /shared/initialized.txt ]; do
    #   sleep 1
    # done

    BINARY="op-reth"

    ADDITIONAL_ARGS="${ADDITIONAL_ARGS:-} --rollup.sequencer-http=https://mainnet-sequencer.optimism.io"

    # if [ -z "${IS_CUSTOM_CHAIN}" ]; then
    #   if [ "$NETWORK_NAME" == "op-mainnet" ] || [ "$NETWORK_NAME" == "op-goerli" ]; then
    #     export EXTENDED_ARG="${EXTENDED_ARG:-} --rollup.historicalrpc=${OP_GETH__HISTORICAL_RPC:-http://l2geth:8545} --op-network=$NETWORK_NAME"
    #   else
    #     export EXTENDED_ARG="${EXTENDED_ARG:-} --op-network=$NETWORK_NAME"
    #   fi
    # fi
    #
    # # Init genesis if custom chain
    # if [ -n "${IS_CUSTOM_CHAIN}" ]; then
    #   geth init --datadir="$BEDROCK_DATADIR" /chainconfig/genesis.json
    # fi
else
    echo "expected base or optimism" 1>&2
    exit 1
fi


mkdir -p "/data"
echo "688f5d737bad920bdfb2fc2f488d6b6209eebda1dae949a8de91398d932c517a" > "/tmp/engine-auth-jwt"

exec "$BINARY" node \
  -vvv \
  $ADDITIONAL_ARGS $@
