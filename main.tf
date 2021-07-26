resource "hcloud_floating_ip" "k3s" {
  type      = "ipv4"
  home_location = var.location
}

resource "hcloud_floating_ip_assignment" "k3s" {
  floating_ip_id = hcloud_floating_ip.k3s.id
  server_id      = module.k3s.server_id
}

module "k3s" {
  source = "./k3s"
  hcloud_token = var.hcloud_token
  clustername = var.clustername
  public_ip_override = hcloud_floating_ip.k3s.ip_address
  ssh_keys = [hcloud_ssh_key.root.name]
  location = var.location
}
