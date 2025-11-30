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
    BINARY="op-reth"

    ADDITIONAL_ARGS="${ADDITIONAL_ARGS:-} --rollup.sequencer-http=https://mainnet-sequencer.optimism.io"
else
    echo "expected base or optimism" 1>&2
    exit 1
fi


mkdir -p "/data"
echo "688f5d737bad920bdfb2fc2f488d6b6209eebda1dae949a8de91398d932c517a" > "/tmp/engine-auth-jwt"

exec "$BINARY" node \
  -vvv \
  $ADDITIONAL_ARGS $@
