# CI PHP Lint

[![CircleCI](https://circleci.com/gh/bangpound/ci-php-lint.svg?style=svg&circle-token=254a04057054e9674d8968f090fdac9930cf72b6)](https://circleci.com/gh/bangpound/ci-php-lint)

Runs the PHP linter on files in a changeset.

Install
-------

Run `make` and copy the product `dist/circleci-php-lint` into your project.

Usage
-----

bin/circleci-php-lint [options]

  -C           [arg] Git repository directory.
  -i --include [arg] Grep include pattern. Required. Default='\.php$'
  -x --exclude [arg] Grep exclude pattern.
  -v                 Enable verbose mode, print script as it is executed
  -d --debug         Enables debug mode
  -h --help          This page
  -n --no-color      Disable color output



Example
-------

Lint changed php files for the current build in the current working
directory.

```
bin/circleci-php-lint
```

Lint changed php files in the `src` directory:

```
bin/circleci-php-lint -i ^src\/.+\.php$
```

Lint changed php files except in the test directory:

```
bin/circleci-php-lint -x ^test
```

Use a different PHP than the default:

```
PHP_BIN=~/.php/5.3/bin/php bin/circleci-php-lint
```

## Terms

* revision - this value varies based on the trigger for a given build.
  When the trigger is a pull request, it is a pair of git commit hashes
  representing the BASE and HEAD commit for that pull request.
  When the trigger is a push to a branch or a pull request, it is a pair
  of git commit hashes representing the new commits in that push.
  In some other circumstances, it will be a single commit hash.

## CircleCI

Add this to the `circle.yml` configuration file:

```yaml
test:
  pre:
    # Run php -l on application files using PHP v5.3
    - PHP_BIN=/home/ubuntu/.phpenv/versions/5.3.10/bin/php circleci-php-lint -x '^features'
    # Run php -l on non-application Behat files using PHP v5.4
    - PHP_BIN=/home/ubuntu/.phpenv/versions/5.4.15/bin/php circleci-php-lint -i '^features/.+\.php$'
```

CircleCI defines environment variables which allow this script to determine the
changeset for the current build. Some of these variables are not available
in difference circumstances, so this script uses multiple strategies to
determine the changeset.

`CIRCLE_COMPARE_URL` is the ideal source for the revision reference.

If you define `CIRCLECI_TOKEN` then the CircleCI REST API data for the build
will be used as a backup when `CIRCLE_COMPARE_URL` is not available.
The JSON response is parsed for the `all_commit_details` list, and the first
and last element's `commit` property is used to construct the revision

Components
----------

Main function:

* `bin/circleci-php-lint` - test script meant to be run as a test in CircleCI builds.
  This script is based on the [BASH3 Boilerplate](http://bash3boilerplate.sh). It
  loads the function scripts in `src/` and then calls `circleci_main`.
* `bin/circleci_main.sh` - the main function for the script.

Included functions:

* `src/circleci_rest.sh TOKEN USER PROJECT BUILD` - returns the revision for a given
  build based on the [CircleCI REST API](https://circleci.com/docs/api/#build). This
  script uses only the `all_commit_details` property.
* `src/changed_files.sh DIR [BASE] HEAD` - returns a list of all changed files in
  the git repository at DIR between BASE and HEAD hash. If BASE is not defined, it
  is HEAD^.
* `src/lint_php.sh` - calls `php -l` on stdin.
* `src/url_to_hash.sh URL` - returns a single commit hash or pair of commit hashes
  that is the revision for the build.

Unused functions:

* `src/circleci_env.sh TOKEN` - uses other CircleCI environment variables to determine
  the revision based on the pull request ID in GitHub. `TOKEN` is a GitHub access
  token. (not used)
* `src/github_rest.sh TOKEN USER PROJECT ISSUE` - calls GitHub REST API to retrieve
  the range of commits for a given pull request. (not used)
* `src/url_to_pull_request_id.sh URL` - returns an ID from a URL for a GitHub pull
  request. (not used)

Acknowledgements
----------------

* [BASH3 Boilerplate](http://bash3boilerplate.sh)
* [phpLintBash](https://github.com/njoannidi/phpLintBash)
* [Git PHP Lint](https://github.com/M1ke/git-php-lint)
