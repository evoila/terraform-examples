data "vsphere_datacenter" "datacenter" {
  name = "SiteA"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Cluster-SiteA"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_resource_pool" "pool" {
  name                    = "terraform-permission-order-demo"
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

data "vsphere_role" "administrator" {
  label = "Administrator"
}

resource "vsphere_entity_permissions" "permissions" {
  entity_id = vsphere_resource_pool.pool.id
  entity_type = "ResourcePool"

  permissions {
    user_or_group = "vsphere.local\\terraform-demo"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
  }

  permissions {
    user_or_group = "vsphere.local\\nfeldhausen"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
  }

  permissions {
    user_or_group = "vsphere.local\\sbaier"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
  }
}