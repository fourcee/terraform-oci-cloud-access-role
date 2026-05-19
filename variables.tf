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
  type = list(string)
}
