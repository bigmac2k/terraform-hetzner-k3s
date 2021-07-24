terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = ">= 1.27.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.2.0"
    }
  }
}

variable "hcloud_token" {}

provider "hcloud" {
  token = var.hcloud_token
}

provider "helm" {
  kubernetes {
    host = module.masterpool.host
    client_certificate = base64decode(module.masterpool.cert)
    client_key = base64decode(module.masterpool.key)
    cluster_ca_certificate = base64decode(module.masterpool.ca)
  }
}
