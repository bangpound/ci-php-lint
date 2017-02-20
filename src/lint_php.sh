#!/usr/bin/env bash

function lint_php() {
    if [ -z "${PHP_BIN:-}" ]; then
        PHP_BIN=$(which php)
    fi
    if [ ! -x "${PHP_BIN}" ] || [ ! -f "${PHP_BIN}" ]; then
        echo "PHP executable ${PHP_BIN} does not exist."
        return 1
    fi
    output=$($PHP_BIN --no-php-ini --syntax-check -ddisplay_errors\=1 -derror_reporting\=E_ALL -dlog_errors\=0 2>&1 <&0)
    status=$?
    echo "$output"
    return $status
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f lint_php
else
    lint_php "${@}"
    exit ${?}
fi
