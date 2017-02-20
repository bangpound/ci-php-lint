#!/usr/bin/env bats

load test_helper

setup() {
    run fixture_repository
}

@test "Changed Files / list from beginning to end" {
    changes="CHANGELOG
binary.jpg
go/example.go
json/long.json
json/short.json
php/crappy.php
vendor/foo.go"
    run src/changed_files.sh tmp/fixtures/basic b029517f 6ecf0ef2

    [ $status -eq 0 ]
    [ "$output" = "$changes" ]
}

@test "Changed Files / list for one commit" {
    changes="vendor/foo.go"
    run src/changed_files.sh tmp/fixtures/basic 6ecf0ef2^ 6ecf0ef2

    [ $status -eq 0 ]
    [ "$output" = "$changes" ]
}
