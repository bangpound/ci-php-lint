#!/usr/bin/env bats

load test_helper

setup() {
    if [ -e .env ]; then
        . .env
    fi
    if [ -z "$CIRCLECI_TOKEN" ]; then
        skip "set CIRCLECI_TOKEN"
    fi
    vcs_type=github
    username=bangpound
    project=circleci-php-lint
    build_num=29
}

@test "CircleCI REST / get base and head for a pull request" {
    run src/circleci_rest.sh \
        $CIRCLECI_TOKEN \
        $vcs_type \
        $username \
        $project \
        $build_num

    [ $status -eq 0 ]
    [ "$output" == "8459a2ba732cfa0e0aceae76b49b08504e05485e b03f6ce53246367c943894a68ef4d0da165b6405" ]
}
