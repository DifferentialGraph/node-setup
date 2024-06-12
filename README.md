# Node Setup
Automatically setup blockchains full/archive node.

## Ethereum
https://github.com/ledgerwatch/erigon

| Host  | Port  | Protocol  |        Purpose         | Expose  |
|:-----:|:-----:|:---------:|:----------------------:|:-------:|
| 30303 | 30303 | TCP & UDP |     eth/66 peering     | Public  |
| 30304 | 30304 | TCP & UDP |     eth/67 peering     | Public  |
| 9090  | 9090  |    TCP    |    gRPC Connections    | Private |
| 42069 | 42069 | TCP & UDP | Snap sync (Bittorrent) | Public  |
| 6060  | 6060  |    TCP    |    Metrics or Pprof    | Private |
| 6061  | 6061  |    TCP    |    Metrics or Pprof    | Private |
| 8551  | 8551  |    TCP    | Engine API (JWT auth)  | Private |


## Arbitrum-One
https://docs.arbitrum.io/node-running/how-tos/running-an-archive-node

## Gnosis
https://docs.gnosischain.com/node/

### `execution` layer
| Host           | Port  | Protocol  |        Purpose              | Expose  |
|:--------------:|:-----:|:---------:|:---------------------------:|:-------:|
| 0.0.0.0:30303  | 30303 | TCP & UDP |     eth/66 peering          | Public  |
| 0.0.0.0:30304  | 30304 | TCP & UDP |     eth/67 peering          | Public  |
| 0.0.0.0:42069  | 42069 | TCP & UDP | Snap sync (Bittorrent)      | Public  |
| Closed         | 6060  |    TCP    |    Metrics                  | Private |
| Closed         | 6061  |    TCP    |    Pprof                    | Private |
| Closed         | 8551  |    TCP    | Engine API (JWT auth)       | Private |
| 127.0.0.1:8555 | 8545	 |    TCP	 | HTTP & WebSockets & GraphQL | Private |

### `consensus` layer
| Host           | Port  | Protocol  |        Purpose              | Expose  |
|:--------------:|:-----:|:---------:|:---------------------------:|:-------:|
| 0.0.0.0:9010   | 9000  | TCP & UDP |     p2p                     | Public  |
| 0.0.0.0:5064   | 5054  |    TCP    | Metrics                     | Public  |
| Closed         | 4000  |    TCP    | http                        | Public  |

## Avalanche

- Avalanche node config: https://docs.avax.network/nodes/maintain/avalanchego-config-flags
- Avalanche C chain config: https://docs.avax.network/quickstart/integrate-exchange-with-avalanche