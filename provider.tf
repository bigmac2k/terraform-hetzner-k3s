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
    host = module.k3s.host
    client_certificate = base64decode(module.k3s.cert)
    client_key = base64decode(module.k3s.key)
    cluster_ca_certificate = base64decode(module.k3s.ca)
  }
}

provider "kubernetes" {
  host = module.k3s.host
  client_certificate = base64decode(module.k3s.cert)
  client_key = base64decode(module.k3s.key)
  cluster_ca_certificate = base64decode(module.k3s.ca)
}

provider "kubernetes-alpha" {
  host = module.k3s.host
  client_certificate = base64decode(module.k3s.cert)
  client_key = base64decode(module.k3s.key)
  cluster_ca_certificate = base64decode(module.k3s.ca)
}

provider "kubectl" {
  host = module.k3s.host
  client_certificate = base64decode(module.k3s.cert)
  client_key = base64decode(module.k3s.key)
  cluster_ca_certificate = base64decode(module.k3s.ca)
}
