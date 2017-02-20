#!/usr/bin/env bats

load test_helper

setup() {
    github_user=github
    github_project=hub
    compare_url=https://github.com/"$github_user"/"$github_project"/compare
    compare_start_sha=1b269ea15dc6
    compare_end_sha=3d3facba2c53
    commit_sha1=e43d204db5233b51169fc755ab979bb9c4ebe663
    commit_url=https://github.com/"$github_user"/"$github_project"/commit/"$commit_sha1"
}

@test "URL to hash / require a URL" {
    run src/url_to_hash.sh
    [ $status -eq 1 ]
    [[ "$output" =~ "Supply a valid URL" ]]
}

@test "URL to hash / require a valid URL" {
    run src/url_to_hash.sh "$compare_url"
    [ $status -eq 1 ]
    [[ "$output" =~ "Supply a valid URL" ]]
}

@test "URL to hash / parse single commit from github url" {
    run src/url_to_hash.sh "$commit_url"

    [ $status -eq 0 ]
    [ "$output" == "$commit_sha1" ]
}

@test "URL to hash / parse start and end hash from github url" {
    run src/url_to_hash.sh "$compare_url/$compare_start_sha...$compare_end_sha"

    [ $status -eq 0 ]
    [ "$output" == "$compare_start_sha $compare_end_sha" ]
}
