#!/usr/bin/env bash

function changed_files() {
    local dir=${1:-}
    local start=${2:-}
    local end=${2:-}
    if [ -n "${3:-}" ]; then
        end=${3:-}
    fi
    local output
    local status

    if [[ "$start" = "$end" ]]; then
        start="$start^"
    fi

    output=$(git -C "$dir" diff --name-status --diff-filter=d --no-renames "$start" "$end" 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
        echo "$output" | cut -c 3-
    fi

    return $status
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f changed_files
else
    changed_files "${@}"
    exit ${?}
fi
