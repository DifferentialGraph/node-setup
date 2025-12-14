#!/bin/sh
set -e

get_public_ip() {
  # Define a list of HTTP-based providers
  # local PROVIDERS=(
  #   "http://ifconfig.me"
  #   "http://api.ipify.org"
  #   "http://ipecho.net/plain"
  #   "http://v4.ident.me"
  # )
  # Iterate through the providers until an IP is found or the list is exhausted
  # for provider in "${PROVIDERS[@]}"; do
  #   local IP
  #   IP=$(curl -s --max-time 10 --connect-timeout 5 "$provider")
  #   # Check if IP contains a valid format (simple regex for an IPv4 address)
  #   if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  #     echo "$IP"
  #     return 0
  #   fi
  # done
  return 1
}

# # Wait for the Bedrock flag for this network to be set.
# echo "Waiting for Bedrock node to initialize..."
# while [ ! -f /shared/initialized.txt ]; do
#   sleep 1
# done
ADDITIONAL_ARGS=""

if [ $OPSTACK_CHAIN == "optimism" ]; then
  export ADDITIONAL_ARGS="${ADDITIONAL_ARGS:-} --network=op-mainnet --rollup.load-protocol-versions=true --rollup.halt=major"
elif [ $OPSTACK_CHAIN == "base" ]; then
  export OP_NODE_NETWORK=base-mainnet
fi

echo "688f5d737bad920bdfb2fc2f488d6b6209eebda1dae949a8de91398d932c517a" > "/tmp/engine-auth-jwt"

exec op-node \
  $ADDITIONAL_ARGS $@
