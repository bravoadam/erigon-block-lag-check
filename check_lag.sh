#!/bin/bash

LOCAL_RPC="http://127.0.0.1:8545"
REMOTE_RPC="https://polygon-rpc.com"

while true; do
  # Fetch local block number
  LOCAL_BLOCK_HEX=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    -H "Content-Type: application/json" "$LOCAL_RPC" | jq -r '.result')
  LOCAL_BLOCK_HEX_CLEAN=$(echo "$LOCAL_BLOCK_HEX" | sed 's/^0x//')
  LOCAL_BLOCK=$((16#$LOCAL_BLOCK_HEX_CLEAN))

  # Fetch remote block number
  REMOTE_BLOCK_HEX=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    -H "Content-Type: application/json" "$REMOTE_RPC" | jq -r '.result')
  REMOTE_BLOCK_HEX_CLEAN=$(echo "$REMOTE_BLOCK_HEX" | sed 's/^0x//')
  REMOTE_BLOCK=$((16#$REMOTE_BLOCK_HEX_CLEAN))

  # Calculate block lag
  DIFF=$((REMOTE_BLOCK - LOCAL_BLOCK))

  # Print to console
  echo "$(date '+%Y-%m-%d %H:%M:%S') | Local: $LOCAL_BLOCK | Remote: $REMOTE_BLOCK | Lag: $DIFF blocks"

  # Wait before next check
  sleep 5
done
