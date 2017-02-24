#!/usr/bin/env bats

load test_helper

setup() {
    repo_dir=tmp/test-git
    mkdir -p $repo_dir

    # hides output
    git -C $repo_dir init > /dev/null

    # empty initial commit allows us to tests diff of first real commit.
    GIT_AUTHOR_DATE="Thu, 01 Jan 1970 00:00:00 +0000" GIT_COMMITTER_DATE="Thu, 01 Jan 1970 00:00:00 +0000" git -C $repo_dir commit --allow-empty -q -m 'Initial commit'

    echo '<?php phpinfo();' > $repo_dir/index.php
    git -C $repo_dir add index.php
    git -C $repo_dir commit -q -m "added."
    git -C $repo_dir tag t0
    commit1_sha=$(git -C "$repo_dir" rev-list -n 1 t0)

    git -C $repo_dir mv index.php index2.php
    git -C $repo_dir commit -q -m "moved."
    git -C $repo_dir tag t1
    commit2_sha=$(git -C "$repo_dir" rev-list -n 1 t1)
}

teardown() {
    rm -rf $repo_dir
}

@test "check for added index.php" {
    run git -C "$repo_dir" diff --name-status --diff-filter=ACMRTX --no-renames $commit1_sha^ $commit1_sha
    output=$(echo "$output" | cut -c 3-)

    [ $status -eq 0 ]
    [ "$output" = "index.php" ]
}

@test "check for added index2.php" {
    run git -C "$repo_dir" diff --name-status --diff-filter=ACMRTX --no-renames $commit1_sha $commit2_sha
    output=$(echo "$output" | cut -c 3-)

    [ $status -eq 0 ]
    [ "$output" = "index2.php" ]
}

@test "check for added index2.php" {
    run git -C "$repo_dir" diff --name-status --diff-filter=ACMRTX --no-renames $commit2_sha^ $commit2_sha
    output=$(echo "$output" | cut -c 3-)

    [ $status -eq 0 ]
    [ "$output" = "index2.php" ]
}
