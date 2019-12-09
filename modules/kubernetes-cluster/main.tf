resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prefix
  kubernetes_version  = var.kubernetes_version

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.admin_public_ssh_key, "\n", "")
    }
  }

  default_node_pool {
    name                  = lookup(default_node_pool.value, "name", null)
    os_type               = lookup(default_node_pool.value, "os_type", null)
    vm_size               = lookup(default_node_pool.value, "vm_size", null)
    availability_zones    = lookup(default_node_pool.value, "availability_zones", null)
    enable_auto_scaling   = lookup(default_node_pool.value, "enable_auto_scaling", null)
    enable_node_public_ip = lookup(default_node_pool.value, "enable_node_public_ip", null)
    max_pods              = lookup(default_node_pool.value, "max_pods", null)
    node_taints           = lookup(default_node_pool.value, "node_taints", null)
    os_disk_size_gb       = lookup(default_node_pool.value, "os_disk_size_gb", null)
    type                  = lookup(default_node_pool.value, "type", null)
    vnet_subnet_id        = lookup(default_node_pool.value, "vnet_subnet_id", null)
    min_count             = lookup(default_node_pool.value, "min_count", null)
    max_count             = lookup(default_node_pool.value, "max_count", null)
    node_count            = lookup(default_node_pool.value, "node_count", null)
  }

  dynamic "agent_pool_profile" {
    for_each = var.agent_pool_profile
    content {
      name                = lookup(agent_pool_profile.value, "name", null)
      count               = lookup(agent_pool_profile.value, "count", null)
      vm_size             = lookup(agent_pool_profile.value, "vm_size", null)
      availability_zones  = lookup(agent_pool_profile.value, "availability_zones", null)
      enable_auto_scaling = lookup(agent_pool_profile.value, "enable_auto_scaling", null)
      min_count           = lookup(agent_pool_profile.value, "min_count", null)
      max_count           = lookup(agent_pool_profile.value, "max_count", null)
      max_pods            = lookup(agent_pool_profile.value, "max_pods", null)
      os_disk_size_gb     = lookup(agent_pool_profile.value, "os_disk_size_gb", null)
      os_type             = lookup(agent_pool_profile.value, "os_type", null)
      type                = lookup(agent_pool_profile.value, "type", null)
      vnet_subnet_id      = lookup(agent_pool_profile.value, "vnet_subnet_id", null)
      node_taints         = lookup(agent_pool_profile.value, "node_taints", null)
    }
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    pod_cidr           = var.network_profile.pod_cidr
    service_cidr       = var.network_profile.service_cidr
  }

  lifecycle {
    ignore_changes = var.aks_ignore_changes
  }

  tags = var.tags
}
