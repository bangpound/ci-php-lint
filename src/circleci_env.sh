#!/usr/bin/env bash

function circleci_env() {
    GITHUB_TOKEN=$1

    if [ -z "$CIRCLECI" ]
    then
        echo "Cannot run. Missing Circle CI environment variables."
        return 1
    fi

    if [ -n "$CI_PULL_REQUESTS" ]
    then
        for i in ${CI_PULL_REQUESTS//,/ }
        do
            id=$(src/url_to_pull_request_id.sh "$i")
            src/github_rest.sh "$GITHUB_TOKEN" "$CIRCLE_PROJECT_USERNAME" "$CIRCLE_PROJECT_REPONAME" "$id" | sed -E "s/'//g"
        done
    fi

    if [ -n "$CIRCLE_PR_NUMBER" ]
    then
        src/github_rest.sh "$GITHUB_TOKEN" "$CIRCLE_PROJECT_USERNAME" "$CIRCLE_PROJECT_REPONAME" "$CIRCLE_PR_NUMBER" | sed -E "s/'//g"
    fi

    if [ -n "$CIRCLE_COMPARE_URL" ]
    then
        src/url_to_hash.sh "$CIRCLE_COMPARE_URL"
    fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f circleci_env
else
    circleci_env "${@}"
    exit ${?}
fi
