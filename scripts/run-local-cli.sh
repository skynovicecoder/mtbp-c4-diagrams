#!/bin/bash
# Script to run Structurizr CLI locally

# Check if Structurizr CLI exists
if [ ! -f "./structurizr-cli/structurizr-cli" ]; then
  echo "Structurizr CLI not found! Download it first from https://structurizr.com/download"
  exit 1
fi

# Create output folder
mkdir -p output

# Export all DSL files in structurizr/
for dsl in structurizr/*.dsl; do
  echo "Generating diagrams for $dsl ..."
  ./structurizr-cli/structurizr-cli export -workspace "$dsl" -format png -output output
done

echo "Diagrams generated in output/"
