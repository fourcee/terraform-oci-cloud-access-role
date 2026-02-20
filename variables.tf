variable "predefined_policies" {
  description = "List of OCI policy statement templates to assign to the group principals. Use {group} as placeholder for the group name."
  type        = list(string)
  default     = []
}

variable "custom_policies" {
  description = "List of custom OCI policy groups to create and assign"
  type = list(object({
    name        = string
    description = string
    statements  = list(string)
  }))
  default = []
}

variable "group_principals" {
  description = "List of OCI group names to assign policies to"
  type        = list(string)
  default     = []
}

variable "compartment_id" {
  description = "The OCI compartment OCID to assign policies at. Must provide either compartment_id or tenancy_id."
  type        = string
  default     = null
}

variable "tenancy_id" {
  description = "The OCI tenancy OCID to assign policies at. Must provide either compartment_id or tenancy_id."
  type        = string
  default     = null
}
