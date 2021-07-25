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
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.3.2"
    }
    kubernetes-alpha = {
      source = "hashicorp/kubernetes-alpha"
      version = ">= 0.5.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = ">= 1.11.2"
    }
    http = {
      source = "hashicorp/http"
      version = ">= 2.1.0"
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

provider "kubernetes" {
  host = module.masterpool.host
  client_certificate = base64decode(module.masterpool.cert)
  client_key = base64decode(module.masterpool.key)
  cluster_ca_certificate = base64decode(module.masterpool.ca)
}

provider "kubernetes-alpha" {
  host = module.masterpool.host
  client_certificate = base64decode(module.masterpool.cert)
  client_key = base64decode(module.masterpool.key)
  cluster_ca_certificate = base64decode(module.masterpool.ca)
}

provider "kubectl" {
  host = module.masterpool.host
  client_certificate = base64decode(module.masterpool.cert)
  client_key = base64decode(module.masterpool.key)
  cluster_ca_certificate = base64decode(module.masterpool.ca)
}
