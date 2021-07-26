variable "ssh_keys" {
  type        = list
  description = "ssh key names"
}
variable "clustername" {
  type        = string
  description = "name of the cluster"
}
variable "machine_type" {
  type        = string
  default     = "cx21-ceph"
  description = "machine type to use for the k3s machine"
}
variable "extra_ssh_keys" {
  type        = list
  default     = []
  description = "Extra ssh keys to inject into k3s instance"
}
variable "k3s_version" {
  type        = string
  default     = "v1.21.3+k3s1"
  description = "Version of k3s to install"
}
variable "location" {
  type        = string
  default     = "nbg1"
  description = "hetzner location"
}
variable "public_ip_override" {
  type        = string
  default     = ""
}
