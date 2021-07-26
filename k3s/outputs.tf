output "ipv4" {
  value = hcloud_server.k3s.ipv4_address
}
output "ipv6" {
  value = hcloud_server.k3s.ipv6_address
}
output "kubeconfig" {
  value = data.external.get_kubeconfig.result.kubeconfig
}
output "kubeconfig_base64" {
  value = data.external.get_kubeconfig.result.kubeconfig_base64
}
output "host" {
  value = data.external.get_kubeconfig.result.host
}
output "cert" {
  value = data.external.get_kubeconfig.result.cert
}
output "key" {
  value = data.external.get_kubeconfig.result.key
}
output "ca" {
  value = data.external.get_kubeconfig.result.ca
}
