data "vsphere_datacenter" "datacenter" {
  name = "SiteA"
}

data "vsphere_resource_pool" "pool" {
  name          = "terraform-permission-demo"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_role" "administrator" {
  label = "Administrator"
}

resource "vsphere_entity_permissions" "permissions" {
  entity_id = data.vsphere_resource_pool.pool.id
  entity_type = "ResourcePool"

  permissions {
    user_or_group = "vsphere.local\\terraform-demo"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
  }
}