#!/bin/bash

# 1. Load the .env file if it exists
CUSTOMENV=$1

if [ -f $CUSTOMENV ]; then
    # Automatically export all variables in .env
    set -a
    source $CUSTOMENV
    set +a
else
    echo "⚠️  Warning: $CUSTOMENV file not found. Using script defaults."
fi

# 2. Set variables (Use values from .env, or fallback to defaults)
# The syntax ${VAR_NAME:-default} means "Use VAR_NAME if set, else use default"
NETWORK_NAME=${DOCKER_NETWORK_NAME:-my_default_network}
SUBNET=${DOCKER_NETWORK_SUBNET:-172.99.0.0/16}
DRIVER="bridge"
BRIDGE_NAME="br-${BRIDGE_CUSTOM_NAME:-SP17209901}"
# 3. Check and Create
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "✅ Network '$NETWORK_NAME' already exists."
else
    echo "Network '$NETWORK_NAME' not found. Creating..."
    
    docker network create \
      --driver "$DRIVER" \
      --subnet "$SUBNET" \
      -o com.docker.network.bridge.name="$BRIDGE_NAME" \
      "$NETWORK_NAME"

    if [ $? -eq 0 ]; then
        echo "✅ Network '$NETWORK_NAME' created with subnet $SUBNET."
    else
        echo "❌ Error: Failed to create network."
        exit 1
    fi
fi
