#!/usr/bin/env bash

# Set variables
local_branch="$(git rev-parse --abbrev-ref HEAD)"
valid_branch_regex="^((feature|bugfix|hotfix)\/(QDAMOS-)[a-zA-Z0-9._-]*|release\/[a-zA-Z0-9._-]*)+$"
message="There is something wrong with your branch name. Branch names in this project must adhere to this contract: $valid_branch_regex. Your commit will be rejected. You should rename your branch to a valid name and try again."

############################################################
# Run                                                     #
############################################################
echo 'Start check git name branch'

if [[ ! $local_branch =~ $valid_branch_regex ]]; then
  echo $message
  exit 1
fi

echo 'End check git name branch'