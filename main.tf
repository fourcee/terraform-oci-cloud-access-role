locals {
  # Determine if we're working at compartment or tenancy level
  is_compartment_level = var.compartment_id != null
  is_tenancy_level     = var.tenancy_id != null

  # Create combinations of predefined policies and principals
  compartment_predefined_bindings = local.is_compartment_level ? flatten([
    for idx, policy in var.predefined_policies : [
      for principal in var.group_principals : {
        key       = "predefined-${idx}-${principal}"
        policy    = replace(policy, "{group}", principal)
        principal = principal
      }
    ]
  ]) : []

  tenancy_predefined_bindings = local.is_tenancy_level ? flatten([
    for idx, policy in var.predefined_policies : [
      for principal in var.group_principals : {
        key       = "predefined-${idx}-${principal}"
        policy    = replace(policy, "{group}", principal)
        principal = principal
      }
    ]
  ]) : []

  # Create combinations of custom policies and principals
  compartment_custom_bindings = local.is_compartment_level ? flatten([
    for custom in var.custom_policies : [
      for principal in var.group_principals : {
        key         = "${custom.name}-${principal}"
        name        = "${custom.name}-${principal}"
        description = custom.description
        statements  = [for stmt in custom.statements : replace(stmt, "{group}", principal)]
        principal   = principal
      }
    ]
  ]) : []

  tenancy_custom_bindings = local.is_tenancy_level ? flatten([
    for custom in var.custom_policies : [
      for principal in var.group_principals : {
        key         = "${custom.name}-${principal}"
        name        = "${custom.name}-${principal}"
        description = custom.description
        statements  = [for stmt in custom.statements : replace(stmt, "{group}", principal)]
        principal   = principal
      }
    ]
  ]) : []
}

# Assign predefined policies at compartment level
resource "oci_identity_policy" "predefined_compartment" {
  for_each = local.is_compartment_level ? { for binding in local.compartment_predefined_bindings : binding.key => binding } : {}

  compartment_id = var.compartment_id
  name           = "predefined-policy-${each.key}"
  description    = "Predefined policy for ${each.value.principal}"
  statements     = [each.value.policy]
}

# Assign custom policies at compartment level
resource "oci_identity_policy" "custom_compartment" {
  for_each = local.is_compartment_level ? { for binding in local.compartment_custom_bindings : binding.key => binding } : {}

  compartment_id = var.compartment_id
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements
}

# Assign predefined policies at tenancy level
resource "oci_identity_policy" "predefined_tenancy" {
  for_each = local.is_tenancy_level ? { for binding in local.tenancy_predefined_bindings : binding.key => binding } : {}

  compartment_id = var.tenancy_id
  name           = "predefined-policy-${each.key}"
  description    = "Predefined policy for ${each.value.principal}"
  statements     = [each.value.policy]
}

# Assign custom policies at tenancy level
resource "oci_identity_policy" "custom_tenancy" {
  for_each = local.is_tenancy_level ? { for binding in local.tenancy_custom_bindings : binding.key => binding } : {}

  compartment_id = var.tenancy_id
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements
}
