#!/usr/bin/env bats

load test_helper

setup() {
    github_user=github
    github_project=hub
    github_pull_request_id=53

    pull_request_url=https://github.com/"$github_user"/"$github_project"/pull/"$github_pull_request_id"
}

@test "URL to pull request ID / require a URL" {
    run src/url_to_pull_request_id.sh
    [ $status -eq 1 ]
    [[ "$output" =~ "Supply a valid URL" ]]
}

@test "URL to pull request ID / require a valid URL" {
    run src/url_to_pull_request_id.sh https://github.com/"$github_user"/"$github_project"/pull
    [ $status -eq 1 ]
    [[ "$output" =~ "Supply a valid URL" ]]
}

@test "URL to pull request ID / parse pull request id from github url" {
    run src/url_to_pull_request_id.sh "$pull_request_url"

    [ $status -eq 0 ]
    [ $output -eq $github_pull_request_id ]
}
