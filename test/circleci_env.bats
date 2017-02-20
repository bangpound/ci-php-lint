#!/usr/bin/env bats

load test_helper

setup() {
    export CIRCLE_PROJECT_USERNAME=github
    export CIRCLE_PROJECT_REPONAME=hub
    export CIRCLE_SHA1=e43d204db5233b51169fc755ab979bb9c4ebe663
    export CIRCLECI=1
}

@test "CircleCI ENV / use compare url" {
    export CIRCLE_COMPARE_URL=/b029517f6300...6ecf0ef2c2df
    run src/circleci_env.sh $GITHUB_TOKEN
    [ $status -eq 0 ]
    [ "$output" = "b029517f6300 6ecf0ef2c2df" ]
}

@test "CircleCI ENV / use pr list" {
    export CI_PULL_REQUESTS=https://github.com/github/hub/pull/798,https://github.com/github/hub/pull/799
    run src/circleci_env.sh $GITHUB_TOKEN
    [ $status -eq 0 ]
}