#!/bin/bash

# Xcode Cloud post-clone script
# Writes the service account key from environment variable to file

set -e

echo "Running ci_post_clone.sh..."

# Check if the environment variable exists
if [ -z "$THRESH_SERVICE_ACCOUNT_KEY" ]; then
    echo "ERROR: THRESH_SERVICE_ACCOUNT_KEY environment variable is not set"
    exit 1
fi

# Create the Resources directory if it doesn't exist
mkdir -p "$CI_PRIMARY_REPOSITORY_PATH/Thresh/Resources"

# Write the service account key to the file
echo "$THRESH_SERVICE_ACCOUNT_KEY" > "$CI_PRIMARY_REPOSITORY_PATH/Thresh/Resources/thresh-ios-client-key.json"

echo "Service account key written to Thresh/Resources/thresh-ios-client-key.json"
