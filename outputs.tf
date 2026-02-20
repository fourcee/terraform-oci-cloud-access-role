output "policy_ids" {
  description = "Map of policy keys to their OCIDs"
  value = merge(
    { for k, v in oci_identity_policy.predefined_compartment : k => v.id },
    { for k, v in oci_identity_policy.custom_compartment : k => v.id },
    { for k, v in oci_identity_policy.predefined_tenancy : k => v.id },
    { for k, v in oci_identity_policy.custom_tenancy : k => v.id }
  )
}

output "policy_names" {
  description = "Map of policy keys to their names"
  value = merge(
    { for k, v in oci_identity_policy.predefined_compartment : k => v.name },
    { for k, v in oci_identity_policy.custom_compartment : k => v.name },
    { for k, v in oci_identity_policy.predefined_tenancy : k => v.name },
    { for k, v in oci_identity_policy.custom_tenancy : k => v.name }
  )
}

output "assigned_policies" {
  description = "List of all policy statement templates that have been assigned"
  value = distinct(concat(
    var.predefined_policies,
    flatten([for custom in var.custom_policies : custom.statements])
  ))
}

output "assigned_principals" {
  description = "List of all principals that have been assigned policies"
  value       = var.group_principals
}
