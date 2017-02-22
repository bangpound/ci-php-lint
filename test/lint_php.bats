#!/usr/bin/env bats

@test "Lint PHP / good php" {
    run src/lint_php.sh <<< "<?php phpinfo();"
    echo $status
    [ $status -eq 0 ]
    [ "$output" = "No syntax errors detected in -" ]
}

@test "Lint PHP / bad php" {
    run src/lint_php.sh <<< "<?php badphp"
    [ $status -eq 255 ]
    [[ "$output" == *"Parse error: syntax error, unexpected"* ]]
    [[ "$output" == *"Errors parsing -"* ]]
}
