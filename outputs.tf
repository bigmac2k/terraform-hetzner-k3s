output "k3s_ipv4" {
  value = module.k3s.ipv4
}
output "k3s_ipv6" {
  value = module.k3s.ipv6
}
output "kubeconfig_base64" {
  value = module.k3s.kubeconfig_base64
}
