locals {
  rendered_policy_statements = distinct(flatten([
    for principal in var.group_principals : [
      for statement in var.policy_statement_templates :
      replace(
        replace(
          replace(statement, "{principal}", principal),
          "{group}", principal
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
