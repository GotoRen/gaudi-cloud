variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created"
}

variable "network_name" {
  type        = string
  description = "The name of the network being created"
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "subnets" {
  type = list(object({
    name                     = string # The name of the resource
    region                   = string # The GCP region for this subnetwork.
    private_ip_google_access = bool   # When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
    ip_cidr_range            = string # The IP address range of the VPC in CIDR notation.

    # The logging options for the subnetwork flow logs.
    # Setting this value to `null` will disable them.
    # See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.
    log_config = object({
      aggregation_interval = string
      flow_sampling        = number
      metadata             = string
    })

    # An array of configurations for secondary IP ranges for VM instances contained in this subnetwork.
    # The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork.
    # The alias IPs may belong to either primary or secondary ranges.
    secondary_ip_ranges = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))

  description = "The list of subnets being created"
}
