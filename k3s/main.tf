resource "hcloud_server" "master" {
  name = "${var.clustername}-master"
  location = var.location
  image = "ubuntu-20.04"
  server_type = var.master_type
  labels = {
    cluster: var.clustername,
    master: "true"
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
    cluster_ip = hcloud_server.master.ipv4_address
  }
}
