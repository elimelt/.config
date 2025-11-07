#!/bin/bash

set -euo pipefail

# edit run
function er() {
    local tmpfile=$(mktemp)

    vim $tmpfile

    chmod +x $tmpfile

    $tmpfile
    cat $tmpfile | pbcopy
    rm $tmpfile
}

# edit copy
function ec() {
    local tmpfile=$(mktemp)

    vim $tmpfile

    cat $tmpfile | pbcopy
    rm $tmpfile
}
