#!/bin/sh

# Print usage when arguments are not correct or '-h' is provided
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [reference commit hash (default: HEAD~1)] [new commit hash (default: HEAD)]"
    exit 1
fi

referenceCommitHash="$1"

if [ -z "$referenceCommitHash" ]; then
    referenceCommitHash="$(git rev-parse HEAD~1)"
else
    referenceCommitHash="$(git rev-parse "$referenceCommitHash")"
fi

newCommitHash="$2"

if [ -z "$newCommitHash" ]; then
    newCommitHash="HEAD"
else
    newCommitHash="$(git rev-parse "$newCommitHash")"
fi

# Error when an unknown argument is provided
if [ "$3" ]; then
    echo "Unknown argument: $3"
    exit 1
fi

# Get the list of packages that have been updated in the new commit
nix store diff-closures ".?ref=$referenceCommitHash#darwinConfigurations.\"Daniels-MacBook-Pro\".config.system.build.toplevel" ".?ref=$newCommitHash#darwinConfigurations.\"Daniels-MacBook-Pro\".config.system.build.toplevel"
