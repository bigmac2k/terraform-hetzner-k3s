variable "ssh_keys" {
  type        = list
  description = "ssh key names"
}
variable "clustername" {
  type        = string
  description = "name of the cluster"
}
variable "master_type" {
  type        = string
  default     = "cx21-ceph"
  description = "machine type to use for the masters"
}
variable "extra_ssh_keys" {
  type        = list
  default     = []
  description = "Extra ssh keys to inject into Rancher instances"
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
