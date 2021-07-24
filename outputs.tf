output "master_ipv4" {
  value = module.masterpool.ipv4
}
output "master_ipv6" {
  value = module.masterpool.ipv6
}
output "kubeconfig" {
  value = module.masterpool.kubeconfig
}
