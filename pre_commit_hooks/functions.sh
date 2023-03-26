#!/usr/bin/env bash

############################################################
# functions                                               #
############################################################

# return in variable 'return_func'
get_specific_var_environment() {
  if [ -f .env ]; then
    source .env
  fi

  pwd="$(pwd)"
  echo "$pwd"

  local name_var=$1
  local value_var=${!name_var}

  if [[ -z $value_var ]]; then
    echo "Error: Environment variable not declared - $name_var"
    exit 1
  fi

  return_func=$value_var
}