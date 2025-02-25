#!/bin/bash

# Default prompt if none provided
user_prompt="${1:-"which fields mentioned are social sciences?"}"

# Prepare documents
echo "Unzipping example documents..."
rm -rf exampledocs
unzip -q ../exampledocuments.zip -d exampledocs

# Create search index
./create-index.sh -documents exampledocs

# Do example prompt
./prompt.sh "$user_prompt"