#!/usr/bin/env bash

function circleci_main() {
    if [ -z ${CIRCLECI:-} ]
    then
        error "Cannot run. Missing Circle CI environment variables."
        return 1
    fi

    local token=${CIRCLECI_TOKEN:-}
    local vcs_type="github"
    local username=${CIRCLE_PROJECT_USERNAME:-}
    local project=${CIRCLE_PROJECT_REPONAME:-}
    local build_num=${CIRCLE_BUILD_NUM:-}
    local dir=${1:="${PWD}"}
    local grep_include=${2:="\.php$"}
    local grep_exclude=${3:-}
    local method=""
    local hashes=()
    local commits=()

    # The compare URL property is a better source for the actual difference references
    # Otherwise, parse use the first and lest element's commit property in the
    # all_commit_details list. For builds of merges, the all_commit_details list
    # references the head commit on the branches being merged, so the difference between
    # them
    if [ -n "${CIRCLE_COMPARE_URL:-}" ]; then
        hashes=$(url_to_hash ${CIRCLE_COMPARE_URL})
    else
        hashes=$(circleci_rest $token $vcs_type $username $project $build_num)
    fi

    # shorten all the commit hashes so the log is more readable.
    for i in ${hashes[@]}
    do
        commits+=($(git -C "$dir" rev-parse --short $i))
    done
    info "$username/$project build #$build_num [revision "${commits[@]}"]"

    local changes=$(changed_files "$dir" "${commits[@]}")
    if [ ! $? -eq 0 ]; then
        error hey
    fi
    local total=0
    if [ -n "$changes" ]; then
        total=$(echo "$changes" | wc -w | tr -d '[:space:]')
    fi

    info "---"
    info "PHP_BIN=${PHP_BIN:=$(which php)}"
    info "$($PHP_BIN -v)"
    info "---"

    local failed=0
    local passed=0
    local checked=0
    local skipped=0
    local sha1=${commits[${#commits[@]}-1]}
    local input
    local output=""
    local status=0
    for entry in ${changes}
    do
        if [[ "$entry" =~ $grep_include ]] && [[ ! "$entry" =~ $grep_exclude ]]; then
            input=$(git -C "$dir" show "$sha1":"$entry")
            output=$(lint_php <<< "$input")
            status=$?
            if [ $status -eq 0 ]; then
                ((passed ++))
                info ${output// -/} ${entry}
            else
                error "${entry}: ${output}"
                ((failed ++))
            fi
            ((checked ++))
        else
            debug Skipped "$entry"
            ((skipped ++))
        fi
    done

    local lint_outcome="php_lint: total=${total} checked=${checked} skipped=${skipped} passed=${passed} failed=${failed}"

    if [ ${failed} -gt 0 ]; then
        error ${lint_outcome}
        return 1
    else
        info ${lint_outcome}
        return 0
    fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f circleci_main
else
    circleci_main "${@}"
    exit ${?}
fi
