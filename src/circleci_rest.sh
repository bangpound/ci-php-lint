#!/usr/bin/env bash

# invoke this script with your access token, username, repository name, and PR number as arguments.
#
# src/circleci-build-commits.sh FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF github bangpound circleci-php-lint 29
#
# it will return a dyad of commit hashes if successful:
#
# 'dea18013ac1ea32f4ccc80e8ba926b0368d5e4fe' '3fbd6686092350e486314128cb1bf1360b4331b1'
#
# it will return curl's exit code and error message if not.

function circleci_rest() {
    local circle_token=${1:-}
    local vcs_type=${2:-}
    local username=${3:-}
    local project=${4:-}
    local build_num=${5:-}
    local response
    local status

    # If there is not circleci token supplied, exit with an error.
    if [ -z "$circle_token" ]
    then
        echo "You must supply a CircleCI access token."
        return 1
    fi

    response=$(curl --silent --show-error --fail --stderr - \
        -H "Accept: application/json" \
        https://circleci.com/api/v1.1/project/"$vcs_type"/"$username"/"$project"/"$build_num"?circle-token="$circle_token")

    status=$?
    if [ ${status} -eq 0 ]
    then
        hashes=($(eval echo "$(echo "$response" | jq --raw-output '@sh "\([.all_commit_details[0].commit, .all_commit_details[-1].commit])"')"))
        first=${hashes[0]}
        last=${hashes[${#hashes[@]}-1]}
        if [ "$first" == "$last" ]
        then
            echo "$first"
        else
            echo -e "$first $last"
        fi
    else
        echo "$response"
    fi
    return $status
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f circleci_rest
else
    circleci_rest "${@}"
    exit ${?}
fi
