#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PACKAGE_NAME=$1

echo "Deploying package $PACKAGE_NAME to production..."

echo "Just for instance we are using fly.io to deploy the package..."
FLY_TOML="microsites/${PACKAGE_NAME#'@micro-site/'}/fly.toml"
if [ ! -f "$FLY_TOML" ]; then
  echo "Error: Fly configuration file $FLY_TOML not found."
  exit 0
fi
echo "Deploying $PACKAGE_NAME using fly.io..."
fly deploy -c "$FLY_TOML" --remote-only


echo "Deployment of $PACKAGE_NAME completed."
