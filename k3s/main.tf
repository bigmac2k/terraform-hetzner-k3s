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
    automation_key = data.external.ssh_key_generator.result.public_key
    extra_ssh_keys = var.extra_ssh_keys,
    k3s_version = var.k3s_version
  })
}

data "external" "ssh_key_generator" {
  program = ["bash", "${path.module}/ssh_key_generator.sh"]
}

data "external" "get_kubeconfig" {
  program = ["bash", "${path.module}/get_kubeconfig.sh"]

  query = {
    private_key = data.external.ssh_key_generator.result.private_key_base64
    cluster_ip = hcloud_server.master.ipv4_address
  }
}
