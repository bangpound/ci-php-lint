#!/usr/bin/env bash

# invoke this script with your access token, username, repository name, and PR number as arguments.
#
# src/github_rest.sh FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF bangpound composer-constants 1
#
# it will return a dyad of commit hashes if successful:
#
# 'dea18013ac1ea32f4ccc80e8ba926b0368d5e4fe' '3fbd6686092350e486314128cb1bf1360b4331b1'
#
# it will return curl's exit code and error message if not.

function github_pull_request() {
    GITHUB_TOKEN=$1
    GITHUB_USERNAME=$2
    GITHUB_REPONAME=$3
    GITHUB_PR_ID=$4

    # If there is not github token supplied, exit with an error.
    if [ -z "$GITHUB_TOKEN" ]
    then
        echo "You must supply a Github access token."
        return 1
    fi

    response=$(curl --silent --show-error --fail --stderr - \
    -H "Accept: application/vnd.github.v3.raw+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/repos/"$GITHUB_USERNAME"/"$GITHUB_REPONAME"/pulls/"$GITHUB_PR_ID")

    status=$?
    if [ "$status" -eq 0 ];
    then
        eval echo "$(echo "$response" | jq --raw-output '@sh "\([.base.sha, .head.sha])"')"
    else
        echo "$response"
    fi
    return $status
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f github_pull_request
else
    github_pull_request "${@}"
    exit ${?}
fi
