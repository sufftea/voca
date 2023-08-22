#!/bin/bash

test_command="flutter test integration_test --flavor development --dart-define-from-file=./environments/dev.json --dart-define INJECTABLE_ENV=integration"

if [ -n "$1" ]; then
    test_command="flutter test integration_test/$1 --flavor development --dart-define-from-file=./environments/dev.json"
fi

eval $test_command
