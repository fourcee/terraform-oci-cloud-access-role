output "policy_id" {
  value = oci_identity_policy.this.id
}

output "policy_statements" {
  value = local.rendered_policy_statements
}
