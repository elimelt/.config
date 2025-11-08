#!/bin/bash

# Output files to source to stdout
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Use glob patterns directly instead of ls
shopt -s nullglob

for file in "${REPO_ROOT}/util/"*.sh "${REPO_ROOT}/k8s/"*.sh; do
    echo "$file"
done
