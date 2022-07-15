terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
      version = "~> 3.2.8"
    }
  }
}

provider "nsxt" {
  allow_unverified_ssl = true
}