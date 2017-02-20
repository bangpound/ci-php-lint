#!/usr/bin/env bats

load test_helper

setup() {
    if [ -e .env ]; then
        . .env
    fi
    if [ -z "$GITHUB_TOKEN" ]; then
        skip "set GITHUB_TOKEN"
    fi
    github_user=github
    github_project=hub
    github_pull_request_id=53
}

@test "GitHub REST / get base and head for a pull request" {
    run src/github_rest.sh \
        $GITHUB_TOKEN \
        $github_user \
        $github_project \
        $github_pull_request_id

    [ $status -eq 0 ]
    [ "$output" == "f664667814df3e96c56e1287264e06c09c5dd6ef b3ae4228c34e0fba79f1f9366fe4f0de4028da7e" ]
}
