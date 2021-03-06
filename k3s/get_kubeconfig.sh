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
  test -f $(which yq) || error_exit "yq command not detected in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export CLUSTER_IP=\(.cluster_ip)"')"
  [[ -n "${CLUSTER_IP}" ]] || error_exit "cluster_ip not found"
}

function get_kubeconfig() {
  while ! kubeconfig="$(ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -F /dev/null -l root ${CLUSTER_IP} "while ! [ -f /etc/rancher/k3s/k3s.yaml ] || ! cat /etc/rancher/k3s/k3s.yaml; do sleep 5; done")"; do sleep 5; done
  kubeconfig="${kubeconfig/127\.0\.0\.1/${CLUSTER_IP}}"
  server="$(echo "${kubeconfig}" | yq -r '.clusters[0].cluster.server')"
  ca="$(echo "${kubeconfig}" | yq -r '.clusters[0].cluster."certificate-authority-data"')"
  cert="$(echo "${kubeconfig}" | yq -r '.users[0].user."client-certificate-data"')"
  key="$(echo "${kubeconfig}" | yq -r '.users[0].user."client-key-data"')"
  user="$(echo "${kubeconfig}" | yq -r '.users[0].name')"
  while [ "$(curl --output /dev/null --silent --head --fail --write-out '%{http_code}' -k ${server})x" != "401x" ]; do sleep 5; done
  jq -n \
    --arg kubeconfig "${kubeconfig}" \
    --arg host "${server}" \
    --arg cert "${cert}" \
    --arg key "${key}" \
    --arg ca "${ca}" \
    '{"kubeconfig": $kubeconfig, "kubeconfig_base64": $kubeconfig | @base64, "host": $host, "cert": $cert, "key": $key, "ca": $ca}'
}


check_deps
parse_input
get_kubeconfig
