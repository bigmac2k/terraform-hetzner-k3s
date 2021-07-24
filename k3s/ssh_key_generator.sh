#!/bin/bash

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which ssh-keygen) || error_exit "ssh-keygen command not detected in path, please install it"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

function create_ssh_key() {
  trap 'rm -rf "${tmp_dir}"' EXIT
  tmp_dir="$(mktemp -d)"
  export ssh_key_dir="${tmp_dir}"
  ssh-keygen -q -t rsa -b 4096 -N '' -f "${ssh_key_dir}/key"
}

function produce_output() {
  public_key_contents=$(cat ${ssh_key_dir}/key.pub)
  private_key_contents=$(cat ${ssh_key_dir}/key | base64 -w0)
  jq -n \
    --arg public_key "$public_key_contents" \
    --arg private_key "$private_key_contents" \
    '{"public_key":$public_key,"private_key":$private_key | @base64d,"private_key_base64":$private_key}'
}

check_deps
create_ssh_key
produce_output
