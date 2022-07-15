locals {
  switches = flatten([
    for env_key, env in var.environment: [
      for switch in env.switches: [{
        switch_key = "ls-${env_key}-${switch.name}"
        switch_name = switch.name
        switch_cidr = switch.cidr
        environment = env_key
      }
      ]
    ]
  ])
}

data "nsxt_transport_zone" "overlay_transport_zone" {
  display_name = var.tz_name
}

data "nsxt_logical_tier0_router" "tier0_router" {
  display_name = var.tier0_name
}

data "nsxt_edge_cluster" "edge_clusters" {
  display_name = var.edge_cluster_name
}

resource "nsxt_logical_tier1_router" "tier1_routers" {
  for_each = var.environment
  
  description                 = "Tier 1 router for environment ${each.key}"
  display_name                = "t1-terraform-demo-${each.key}"
  edge_cluster_id             = data.nsxt_edge_cluster.edge_clusters.id
  enable_router_advertisement = true
  advertise_connected_routes  = false
  advertise_static_routes     = true
  advertise_nat_routes        = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = false
}

## Link T1 Router with T0 Router ##
resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  for_each = var.environment

  description       = "tier0-router-port-terraform-demo-${each.key}"
  display_name      = "tier0-router-port-terraform-demo-${each.key}"
  logical_router_id = data.nsxt_logical_tier0_router.tier0_router.id
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  for_each = var.environment

  description                   = "tier1-router-port-terraform-demo-${each.key}"
  display_name                  = "tier1-router-port-terraform-demo-${each.key}"
  logical_router_id             = nsxt_logical_tier1_router.tier1_routers[each.key].id
  linked_logical_router_port_id = nsxt_logical_router_link_port_on_tier0.link_port_tier0[each.key].id
}

## Create LS ##
resource "nsxt_logical_switch" "switches" {
  for_each = {for switch in local.switches: switch.switch_key => switch}

  admin_state       = "UP"
  description       = "Logical Switch ${each.value.switch_name} in environment ${each.value.environment}"
  display_name      = "${each.value.switch_name}"
  transport_zone_id = data.nsxt_transport_zone.overlay_transport_zone.id
  replication_mode  = "MTEP"
}

## Connect LS with T1 ##
resource "nsxt_logical_port" "switch_ports" {
  for_each = {for switch in local.switches: switch.switch_key => switch}

  admin_state       = "UP"
  description       = "${each.value.switch_name}-switch-downlink-port"
  display_name      = "${each.value.switch_name}-switch-downlink-port"
  logical_switch_id = nsxt_logical_switch.switches[each.key].id
}

resource "nsxt_logical_router_downlink_port" "switch_downlink_ports" {
  for_each = {for switch in local.switches: switch.switch_key => switch}

  description                   = "${each.value.switch_name}-downlink-port"
  display_name                  = "${each.value.switch_name}-downlink-port"
  logical_router_id             = nsxt_logical_tier1_router.tier1_routers[each.value.environment].id
  linked_logical_switch_port_id = nsxt_logical_port.switch_ports[each.key].id
  ip_address                    = each.value.switch_cidr
}

