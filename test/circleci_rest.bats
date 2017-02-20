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
    project=ci-php-lint
    build_num=2
}

@test "CircleCI REST / get base and head for a pull request" {
    run src/circleci_rest.sh \
        $CIRCLECI_TOKEN \
        $vcs_type \
        $username \
        $project \
        $build_num

    [ $status -eq 0 ]
    [ "$output" == "59e52704d0360daf624076b075dbd5482fc291d7" ]
}
