#!/usr/bin/env bash

fixture_repository() {
    if [ ! -d tmp ] || [ ! -d tmp/fixtures ] || [ ! -d tmp/fixtures/basic ]; then
        mkdir -p tmp/fixtures/basic
        git clone -q https://github.com/git-fixtures/basic.git tmp/fixtures/basic
    fi
}
