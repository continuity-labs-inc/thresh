#!/bin/bash
set -e
echo "Running ci_post_clone.sh..."

# Debug: show if any THRESH vars exist
echo "Checking for THRESH environment variables..."
env | grep -i THRESH | sed 's/=.*/=<redacted>/' || echo "No THRESH variables found"

if [ -z "$THRESH_SERVICE_ACCOUNT_KEY" ]; then
    echo "WARNING: THRESH_SERVICE_ACCOUNT_KEY not set - skipping key file creation"
    exit 0
fi

mkdir -p "$CI_PRIMARY_REPOSITORY_PATH/Thresh/Resources"
echo "$THRESH_SERVICE_ACCOUNT_KEY" > "$CI_PRIMARY_REPOSITORY_PATH/Thresh/Resources/thresh-ios-client-key.json"
echo "Service account key written to Thresh/Resources/thresh-ios-client-key.json"
