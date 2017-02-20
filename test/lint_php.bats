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
    [ "${lines[0]}" = "Parse error: syntax error, unexpected end of file in - on line 2" ]
    [ "${lines[1]}" = "Errors parsing -" ]
}
