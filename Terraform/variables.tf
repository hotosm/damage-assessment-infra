variable "tenant_id" {
  type        = string
  description = "Azure Tenant Id"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription Id"
}

variable "region" {
  type        = string
  default     = "westeurope"
  description = "Azure region."
}

variable "org_abb" {
  type        = string
  default     = "hot"
  description = "Organisation abbreviation."
}

variable "reg_abb" {
  type        = string
  default     = "weu"
  description = "Azure region abbreviation."
}

variable "env_abb" {
  type        = string
  default     = "dev"
  description = "Environment abbreviation."
}

variable "vm_admin_username" {
  type    = string
  default = ""
}

variable "ssh_keys" {
  type    = map(any)
  default = {}
}

variable "sa_inbound_ip_rules" {
  type    = list(string)
  default = []
}

variable "sa_outbound_ip_rules" {
  type    = list(string)
  default = []
}

variable "sa_config_ip_rules" {
  type    = list(string)
  default = []
}

variable "nsg_allowed_addresses_ssh" {
  type        = list(string)
  default     = []
  description = "Allowed IP addresses - ssh"
}

variable "nsg_allowed_addresses_http" {
  type        = list(string)
  default     = []
  description = "Allowed IP addresses - http"
}

variable "nsg_allowed_addresses_https" {
  type        = list(string)
  default     = []
  description = "Allowed IP addresses - https"
}

variable "vm_cloud_init_script" {
  default     = "VM-Cloud-Init.yaml"
  description = "VM cloud init YAML script"
}

variable "hot_sendgrid_api_key" {
  type      = string
  sensitive = true
}

variable "nginx_api_key" {
  type      = string
  sensitive = true
}

variable "postgres_user_name" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "tags" {
  type = object({
    Environment = string
    Project     = string
    }
  )
  default = {
    "Environment" = "Development"
    "Project"     = "DamageAssessment"
  }
}
