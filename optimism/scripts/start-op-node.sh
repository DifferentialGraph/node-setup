#!/bin/sh
set -eou

# Wait for the Bedrock flag for this network to be set.
echo "Waiting for Bedrock node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
  sleep 1
done

if [ -n "${IS_CUSTOM_CHAIN+x}" ]; then
  export EXTENDED_ARG="${EXTENDED_ARG:-} --rollup.config=/chainconfig/rollup.json"
else
  export EXTENDED_ARG="${EXTENDED_ARG:-} --network=$OP_NETWORK_NAME --rollup.load-protocol-versions=true --rollup.halt=major"
fi

# Start op-node.
exec op-node \
  --l1=$MAINNET_RPC_EXECUTION \
  --l2=http://op-geth:8551 \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  --l2.jwt-secret=/shared/jwt.txt \
  --l1.trustrpc \
  --l1.rpckind=$MAINNET_RPC_TYPE \
  --l1.beacon=$MAINNET_RPC_CONSENSUS \
  --metrics.enabled \
  --metrics.addr=0.0.0.0 \
  --metrics.port=7300 \
  --syncmode=execution-layer \
  $EXTENDED_ARG $@
