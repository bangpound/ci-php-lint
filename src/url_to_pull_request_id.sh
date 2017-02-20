#!/usr/bin/env bash

function url_to_pull_request_id() {
    PULL_REQUEST_URL=$1

    if [[ $PULL_REQUEST_URL =~ .*\/([0-9]+) ]]
    then
        echo "$PULL_REQUEST_URL" | sed -E 's#.*\/([0-9]+)#\1#'
    else
        echo "$0: Supply a valid URL"
        return 1
    fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f url_to_pull_request_id
else
    url_to_pull_request_id "${@}"
    exit ${?}
fi
