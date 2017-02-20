SHELL := /bin/bash

all: test dist

# Removes all build files
.PHONY: clean
clean:
	cd build && $(MAKE) clean
	rm -fr tmp
	rm -fr dist

# Run tests
.PHONY: test
test:
	bats test

# Aggregate into a single script
.PHONY: dist
dist:
	mkdir dist
	cd build && $(MAKE)
	cat bin/circleci-php-lint | sed -e '/### Imports/,$$d' > dist/circleci-php-lint
	. src/circleci_rest.sh
	. src/circleci_main.sh
	. src/changed_files.sh
	. src/url_to_hash.sh
	. src/lint_php.sh
	declare -f circleci_rest >> dist/circleci-php-lint
	declare -f circleci_main >> dist/circleci-php-lint
	declare -f changed_files >> dist/circleci-php-lint
	declare -f url_to_hash >> dist/circleci-php-lint
	declare -f lint_php >> dist/circleci-php-lint
	cat bin/circleci-php-lint | sed -n -e '/### Runtime/,$$p' >> dist/circleci-php-lint
