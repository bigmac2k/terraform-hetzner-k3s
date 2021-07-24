#!/bin/bash

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which ssh-keygen) || error_exit "ssh-keygen command not detected in path, please install it"
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
  test -f $(which base64) || error_exit "base64 command not detected in path, please install it"
  test -f $(which curl) || error_exit "curl command not detected in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export CLUSTER_IP=\(.cluster_ip) PRIVKEY=\(.private_key)"')"
  [[ -n "${CLUSTER_IP}" ]] || error_exit "cluster_ip not found"
  [[ -n "${PRIVKEY}" ]] || error_exit "private_key not found"
}

function get_kubeconfig() {
  trap 'rm -rf "${tmp_dir}"' EXIT
  tmp_dir="$(mktemp -d)"
  (umask 77 && echo "${PRIVKEY}" | base64 -d > "${tmp_dir}/key")
  #while ! kubeconfig="$(SSH_AUTH_SOCK= ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -F /dev/null -i \"${tmp_dir}/key\" -l root \"${CLUSTER_IP}\" \"while ! [ -f /etc/rancher/k3s/k3s.yaml ] || ! cat /etc/rancher/k3s/k3s.yaml; do sleep 5; done\")"; do sleep 5; done
  while ! kubeconfig="$(SSH_AUTH_SOCK= ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -F /dev/null -i "${tmp_dir}/key" -l root ${CLUSTER_IP} "while ! [ -f /etc/rancher/k3s/k3s.yaml ] || ! cat /etc/rancher/k3s/k3s.yaml; do sleep 5; done")"; do sleep 5; done
  kubeconfig="${kubeconfig/127\.0\.0\.1/${CLUSTER_IP}}"
  server="$(echo "${kubeconfig}" | grep server | cut -d : -f 2-)"
  while [ "$(curl --output /dev/null --silent --head --fail --write-out '%{http_code}' -k ${server})x" != "401x" ]; do sleep 5; done
  jq -n --arg kubeconfig "${kubeconfig}" '{"kubeconfig":$kubeconfig}'
}


check_deps
parse_input
get_kubeconfig
