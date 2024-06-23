#!/bin/sh

# Get the project key from the first script argument
PROJECT_KEY=$1
# Get the mode from the second script argument
MODE=$2
# Path to the configuration file
CONFIG_FILE="../../micro-config.json"

# Read the port from the configuration file using jq
PORT=$(jq -r ".${PROJECT_KEY}.micrositeConfig.port" $CONFIG_FILE)

# Check if the port was successfully retrieved
if [ "$PORT" = "null" ] || [ -z "$PORT" ]; then
  echo "Error: Could not find port for project key \"$PROJECT_KEY\" in configuration file."
  exit 1
fi


# Start the Next.js server with the specified port and mode
if [ "$MODE" = "production" ]; then
    echo "Starting Next.js production server for project \"$PROJECT_KEY\" on port $PORT..."
    npx next start -p "$PORT"
else
  echo "Starting Next.js development server for project \"$PROJECT_KEY\" on port $PORT..."
  npx next dev -p "$PORT" --turbo
fi