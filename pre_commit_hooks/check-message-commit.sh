#!/usr/bin/env bash

app="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $app/functions.sh

# Set variables
get_specific_var_environment "JIRA_ALIAS"
alias=$return_func
start_line=`head -n1 $1`
patterns=(
  "^($alias)-[[:digit:]]+: "
  "^($alias)-(VAGRANT): "
  "^($alias)-(XXXX): "
  "^(Merge branch) "
)

############################################################
# Run                                                     #
############################################################
echo 'Start check message commit'

is_valid=false

for pattern in "${patterns[@]}" ; do
  if [[ "$start_line" =~ $pattern ]]; then
    is_valid=true
  fi
done

if ! $is_valid ; then
  echo "Bad commit message, see example: $alias-{1234, VAGRANT, XXXX}: commit message"
  exit 1
fi

echo 'End check message commit'