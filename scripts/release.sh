#!/bin/bash

# Step 1: Generate git tags with changeset
changeset tag

# Step 2: Get the latest tags created by changeset
NEW_TAGS=$(git tag --contains HEAD | grep '^@micro-site/')

# Step 3: Extract unique package names
CHANGED_PACKAGES=$(echo "$NEW_TAGS" | cut -d '@' -f 2 | cut -d '/' -f 2 | sort -u)

# Step 4: If there are changed packages, build them
if [ -n "$CHANGED_PACKAGES" ]; then
  FILTERS=$(echo "$CHANGED_PACKAGES" | sed 's/^/@micro-site\//;s/$/.../;s/\n/ --filter=/g')
  turbo build --filter=$FILTERS

  # Step 5: Check if turbo build succeeded
  if [ $? -eq 0 ]; then
    # Call deploy-to-prod.sh for each changed package
    for PACKAGE in $CHANGED_PACKAGES; do
      ./scripts/deploy-to-prod.sh @micro-site/$PACKAGE
    done
  else
    echo "Turbo build failed"
    exit 1
  fi
else
  echo "No packages have changed since the last tag."
fi

# Step 6: Push the changes and tags
git push --follow-tags
