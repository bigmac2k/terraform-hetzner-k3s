resource "hcloud_server" "k3s" {
  name = "${var.clustername}-k3s"
  location = var.location
  image = "ubuntu-20.04"
  server_type = var.machine_type
  labels = {
    cluster: var.clustername,
  }
  backups = true
  ssh_keys = var.ssh_keys
  user_data = templatefile("${path.module}/server_userdata.tmpl", {
    extra_ssh_keys = var.extra_ssh_keys,
    k3s_version = var.k3s_version
  })
}

data "external" "get_kubeconfig" {
  program = ["bash", "${path.module}/get_kubeconfig.sh"]

  query = {
    cluster_ip = hcloud_server.k3s.ipv4_address
  }
}
