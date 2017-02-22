#!/usr/bin/env bats

setup() {
    github_user=github
    github_project=hub
    github_pull_request_id=53
}

@test "CircleCI REST / fail without CircleCI Token" {
    run src/circleci_rest.sh
    [ $status -eq 1 ]
    [ "$output" == "You must supply a CircleCI access token." ]
}

@test "CircleCI ENV / fail without CircleCI" {
    if [ -n "$CIRCLECI" ]; then
        skip
    fi
    run src/circleci_env.sh
    [ $status -eq 1 ]
    [[ "$output" =~ "Cannot run" ]]
}

@test "GitHub REST / fail without github token" {
    run src/github_rest.sh
    [ $status -eq 1 ]
    [ "$output" == "You must supply a Github access token." ]
}

@test "GitHub REST / fail with invalid github token" {
    run src/github_rest.sh \
        FFF \
        $github_user \
        $github_project \
        $github_pull_request_id

    [ $status -eq 22 ]
    [[ "$output" =~ "401" ]]
}
