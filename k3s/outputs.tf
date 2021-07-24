output "ipv4" {
  value = hcloud_server.master.ipv4_address
}
output "ipv6" {
  value = hcloud_server.master.ipv6_address
}
output "kubeconfig" {
  value = data.external.get_kubeconfig.result.kubeconfig
}
