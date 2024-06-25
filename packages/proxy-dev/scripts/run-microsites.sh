#!/bin/sh

# Extract microsite names from micro-config.json using jq
MICROSITES=$(jq -r 'keys[]' /app/micro-config.json)

for SITE in $MICROSITES; do
  # Extract port for the current microsite
  PORT=$(jq -r --arg site "$SITE" '.[$site].micrositeConfig.port' /app/micro-config.json)

  # Start the service for the current microsite
  PORT=$PORT node microsites/$SITE/server.js &
done

# Start the proxy service
PORT=8443 node packages/proxy-dev/dist/index.js
