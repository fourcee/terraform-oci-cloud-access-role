variable "policy_name" {
  type = string
}

variable "policy_description" {
  type    = string
  default = "Managed by Helix Cloud Access Roles"
}

variable "policy_freeform_tags" {
  description = "Freeform tags to apply to the OCI IAM policy."
  type        = map(string)
  default     = {}
}

variable "policy_compartment_id" {
  type = string
}

variable "policy_scope" {
  type = string
}

variable "policy_statement_templates" {
  type = list(string)
}

variable "group_principals" {
  type    = list(string)
  default = []
}

variable "oci_principals" {
  type = list(object({
    type                 = string # user | dynamic_group
    name                 = string
    identity_domain_name = string
  }))
  default = []

  validation {
    condition = alltrue([
      for principal in var.oci_principals : contains(["user", "dynamic_group"], principal.type)
    ])
    error_message = "Each OCI principal type must be either \"user\" or \"dynamic_group\"."
  }
}
