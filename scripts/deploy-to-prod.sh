#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PACKAGE_NAME=$1

echo "Deploying package $PACKAGE_NAME to production..."

echo "install fly.io..."
curl -L https://fly.io/install.sh | sh
export FLYCTL_INSTALL="/home/runner/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"


FLY_TOML="microsites/${PACKAGE_NAME#'@micro-site/'}/fly.toml"
if [ ! -f "$FLY_TOML" ]; then
  echo "Error: Fly configuration file $FLY_TOML not found."
  exit 0
fi
echo "Deploying $PACKAGE_NAME using fly.io..."
fly deploy -c "$FLY_TOML" --remote-only


echo "Deployment of $PACKAGE_NAME completed."
