#!/usr/bin/env bash

############################################################
# functions                                                #
############################################################
check_invalid_function() {
  local exp="\+[[:space:]]*$1("
  local message="There is a $1() statement! Aborting commit..."
  check_invalid_git_diff $exp "$message"
}

check_invalid_rules() {
  local exp="\+[[:space:]]*$1"
  local message="There is a $2 statement! Aborting commit..."
  check_invalid_git_diff $exp "$message"
}

check_invalid_git_diff() {
  local command=$(git diff --cached | grep -w $1)

  if [[ ! -z $command ]]; then
      echo $2
      exit 1
  fi
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
array_check_functions=('var_dump' 'print_r' 'die' 'dd')
array_check_rules=(
  "php_open_tag=('<?=' 'php short tag <?=')"
)

############################################################
# Run                                                      #
############################################################
echo 'Start check call invalid function'

for check_function in "${array_check_functions[@]}"
do
  check_invalid_function $check_function
done

for check_rule in "${array_check_rules[@]}"
do
  check_invalid_function $check_rule[0] $check_rule[1]
done

echo 'End check call invalid function'