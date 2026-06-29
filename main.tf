locals {
  group_policy_principals = [
    for principal in var.group_principals : {
      principal = principal
      group     = principal
    }
  ]

  oci_policy_principals = [
    for principal in var.oci_principals : {
      principal = "${principal.type == "dynamic_group" ? "dynamic-group" : "user"} ${principal.identity_domain_name}/${principal.name}"
      group     = principal.name
    }
  ]

  policy_principals = concat(local.group_policy_principals, local.oci_policy_principals)

  rendered_policy_statements = distinct(flatten([
    for principal in local.policy_principals : [
      for statement in var.policy_statement_templates :
      replace(
        replace(
          replace(statement, "{principal}", principal.principal),
          "{group}", principal.group
        ),
        "{scope}", var.policy_scope
      )
    ]
  ]))
}

resource "oci_identity_policy" "this" {
  compartment_id = var.policy_compartment_id
  name           = var.policy_name
  description    = var.policy_description
  statements     = local.rendered_policy_statements
  freeform_tags  = var.policy_freeform_tags
}
