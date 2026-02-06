#!/bin/bash
CUSTOMENV=$1
# 1. Load .env
if [ -f $CUSTOMENV ]; then
    set -a; source $CUSTOMENV; set +a
fi

# 2. Configuration
NETWORK_NAME=${DOCKER_NETWORK_NAME:-my_default_network}

# 3. Check if network exists
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "⚠️  Network '$NETWORK_NAME' does not exist. Nothing to do."
    exit 0
fi

# 4. Check for attached containers
# We use --format to extract just the names of attached containers
ATTACHED_CONTAINERS=$(docker network inspect "$NETWORK_NAME" --format='{{range .Containers}}{{.Name}} {{end}}')

if [ -n "$ATTACHED_CONTAINERS" ]; then
    # -n means "string is not empty"
    echo "❌ Cannot remove network '$NETWORK_NAME'."
    echo "   It is currently being used by the following containers:"
    echo "   -----------------------------------------------------"
    # Print containers on new lines for readability
    echo "$ATTACHED_CONTAINERS" | tr ' ' '\n' | sed '/^$/d' | sed 's/^/   - /'
    echo "   -----------------------------------------------------"
    echo "   Please stop/disconnect these containers first."
    exit 1
else
    # 5. Remove the network
    docker network rm "$NETWORK_NAME"
    if [ $? -eq 0 ]; then
        echo "✅ Network '$NETWORK_NAME' has been successfully removed."
    else
        echo "❌ Error removing network."
        exit 1
    fi
fi
