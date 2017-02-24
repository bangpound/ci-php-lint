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
	if [ ! -d "dist" ]; then mkdir dist; fi
	cd build && $(MAKE)
	cat bin/circleci-php-lint | sed -e '/\#\#\# Imports/,$$d' > dist/circleci-php-lint

	. src/circleci_rest.sh && declare -f circleci_rest >> dist/circleci-php-lint
	. src/circleci_main.sh && declare -f circleci_main >> dist/circleci-php-lint
	. src/changed_files.sh && declare -f changed_files >> dist/circleci-php-lint
	. src/url_to_hash.sh   && declare -f url_to_hash >> dist/circleci-php-lint
	. src/lint_php.sh      && declare -f lint_php >> dist/circleci-php-lint

	cat bin/circleci-php-lint | sed -n -e '/\#\#\# Runtime/,$$p' >> dist/circleci-php-lint
	chmod +x dist/circleci-php-lint
