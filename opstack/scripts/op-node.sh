#!/bin/bash
set -eu

ADDITIONAL_ARGS=""

if [ $CHAIN == "optimism" ]; then
    export OP_NODE_NETWORK=op-mainnet

    # Wait for the Bedrock flag for this network to be set.
    echo "Waiting for Bedrock node to initialize..."
    while [ ! -f /shared/initialized.txt ]; do
      sleep 1
    done

    export ADDITIONAL_ARGS="${ADDITIONAL_ARGS:-} --network=$NETWORK_NAME --rollup.load-protocol-versions=true --rollup.halt=major"
elif [ $CHAIN == "base" ]; then
    export OP_NODE_NETWORK=base-mainnet

    get_public_ip() {
      # Define a list of HTTP-based providers
      local PROVIDERS=(
        "http://ifconfig.me"
        "http://api.ipify.org"
        "http://ipecho.net/plain"
        "http://v4.ident.me"
      )
      # Iterate through the providers until an IP is found or the list is exhausted
      for provider in "${PROVIDERS[@]}"; do
        local IP
        IP=$(curl -s --max-time 10 --connect-timeout 5 "$provider")
        # Check if IP contains a valid format (simple regex for an IPv4 address)
        if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
          echo "$IP"
          return 0
        fi
      done
      return 1
    }


    # wait until local execution client comes up (authed so will return 401 without token)
    until [ "$(curl -s --max-time 10 --connect-timeout 5 -w '%{http_code}' -o /dev/null "${OP_NODE_L2_ENGINE_RPC/ws/http}")" -eq 401 ]; do
      echo "waiting for execution client to be ready"
      sleep 5
    done

    # public-facing P2P node, advertise public IP address
    if PUBLIC_IP=$(get_public_ip); then
      echo "fetched public IP is: $PUBLIC_IP"
    else
      echo "Could not retrieve public IP."
      exit 8
    fi
    export OP_NODE_P2P_ADVERTISE_IP=$PUBLIC_IP
fi

echo "688f5d737bad920bdfb2fc2f488d6b6209eebda1dae949a8de91398d932c517a" > "/tmp/engine-auth-jwt"

exec op-node \
  $ADDITIONAL_ARGS $@
