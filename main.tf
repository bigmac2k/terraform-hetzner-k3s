module "masterpool" {
  source = "./k3s"
  hcloud_token = var.hcloud_token
  clustername = var.clustername
  ssh_keys = [hcloud_ssh_key.root.name]
}
