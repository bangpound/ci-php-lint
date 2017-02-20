#!/usr/bin/env bash

# example:
# src/url_to_hash.sh https://github.com/github/hub/compare/1b269ea15dc6...3d3facba2c53

function url_to_hash() {
    COMPARE_URL=$1

    if [[ $COMPARE_URL =~ .*\/([0-9A-Fa-f]{12})\.{3}([0-9A-Fa-f]{12}).* ]]
    then
        echo "$COMPARE_URL" | sed -E 's#.*\/([0-9A-Fa-f]{12})\.{3}([0-9A-Fa-f]{12}).*#\1 \2#'
    elif [[ $COMPARE_URL =~ .*\/([0-9A-Fa-f]{12,}).* ]]
    then
        echo "$COMPARE_URL" | sed -E 's#.*\/([0-9A-Fa-f]{12,}).*#\1#'
    else
        echo "$0: Supply a valid URL"
        return 1
    fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f url_to_hash
else
    url_to_hash "${@}"
    exit ${?}
fi

