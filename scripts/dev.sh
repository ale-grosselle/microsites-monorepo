#!/bin/sh

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <project_key>"
  exit 1
fi

# Get the project key from the first script argument
PROJECT_KEY=$1

# Path to the configuration file
CONFIG_FILE="../../micro-config.json"

# Read the port from the configuration file using jq
PORT=$(jq -r ".${PROJECT_KEY}.micrositeConfig.port" $CONFIG_FILE)

# Check if the port was successfully retrieved
if [ "$PORT" = "null" ] || [ -z "$PORT" ]; then
  echo "Error: Could not find port for project key \"$PROJECT_KEY\" in configuration file."
  exit 1
fi

# Start the Next.js development server with the specified port and turbo mode
echo "Starting Next.js development server for project \"$PROJECT_KEY\" on port $PORT..."
npx next dev -p "$PORT" --turbo
