#!/usr/bin/env bash
LC_ALL=C

echo 'start pre-commit'

local_branch="$(git rev-parse --abbrev-ref HEAD)"

valid_branch_regex="^((feature|bugfix|hotfix)\/(QDAMOS-)[a-zA-Z0-9._-]*|release\/[a-zA-Z0-9._-]*|(master|develop|demo))+$"

message="There is something wrong with your branch name. Branch names in this project must adhere to this contract: $valid_branch_regex. Your commit will be rejected. You should rename your branch to a valid name and try again."

if [[ ! $local_branch =~ $valid_branch_regex ]]
then
    echo "$message"
    exit 1
fi

VAR=$(git diff --cached | grep -w "\+[[:space:]]*var_dump(")
if [ ! -z "$VAR" ]; then
    printf "\n"
    echo "There is a var_dump() statement! Aborting commit..."
    printf "\n"
    echo "$VAR"
    exit 1
fi

VAR=$(git diff --cached | grep -w "\+[[:space:]]*<?=")
if [ ! -z "$VAR" ]; then
    printf "\n"
    echo "There is a php short tag <?= statement! Aborting commit..."
    printf "\n"
    echo "$VAR"
    exit 1
fi

VAR=$(git diff --cached | grep -w "\+[[:space:]]*print_r(")
if [ ! -z "$VAR" ]; then
    printf "\n"
    echo "There is a print_r() statement! Aborting commit..."
    printf "\n"
    echo "$VAR"
    exit 1
fi

DIE=$(git diff --cached | grep -w "\+[[:space:]]*die(")
if [ ! -z "$DIE" ]; then
    printf "\n"
    echo "There is a die() statement! Aborting commit..."
    printf "\n"
    echo "$DIE"
    exit 1
fi

DD=$(git diff --cached | grep -w "\+[[:space:]]*dd(")
if [ ! -z "$DD" ]; then
    printf "\n"
    echo "There is a dd() statement! Aborting commit..."
    printf "\n"
    echo "$DD"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  docker exec docker_web-api-1 composer php-cs-fixer 2>/dev/null && git add .
elif [[ "$OSTYPE" == "darwin"* ]]; then
  php composer php-cs-fixer
fi

echo 'end pre-commit'
exit 0