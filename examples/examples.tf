# Example configurations for the OCI IAM Assignment Module

# Example 1: Compartment-level IAM assignment for OCI groups
module "compartment_group_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "dev-group-access"
  policy_compartment_id = "ocid1.compartment.oc1..examplecompartmentid"
  policy_scope          = "compartment dev"

  policy_statement_templates = [
    "Allow group {group} to read all-resources in {scope}",
    "Allow group {group} to use instances in {scope}",
    "Allow group {group} to read objects in {scope}"
  ]

  group_principals = [
    "Developers",
    "Analysts"
  ]
}

# Example 2: Compartment-level IAM assignment for typed OCI principals
module "compartment_typed_principal_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "dev-typed-principal-access"
  policy_compartment_id = "ocid1.compartment.oc1..examplecompartmentid"
  policy_scope          = "compartment dev"

  policy_statement_templates = [
    "Allow {principal} to read all-resources in {scope}",
    "Allow {principal} to use instances in {scope}"
  ]

  oci_principals = [
    {
      type                 = "user"
      name                 = "alice@example.com"
      identity_domain_name = "Default"
    },
    {
      type                 = "dynamic_group"
      name                 = "instance-workers"
      identity_domain_name = "Default"
    }
  ]
}

# Example 3: Tenancy-level IAM assignment for a dynamic group
module "tenancy_dynamic_group_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "tenancy-dynamic-group-access"
  policy_compartment_id = "ocid1.tenancy.oc1..exampletenancyid"
  policy_scope          = "tenancy"

  policy_statement_templates = [
    "Allow {principal} to inspect compartments in {scope}",
    "Allow {principal} to read all-resources in {scope}"
  ]

  oci_principals = [
    {
      type                 = "dynamic_group"
      name                 = "audit-agents"
      identity_domain_name = "Default"
    }
  ]
}

# Example 4: Multiple typed principals with the same policy templates
module "multi_typed_principal_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "prod-typed-principal-access"
  policy_compartment_id = "ocid1.compartment.oc1..examplecompartmentid"
  policy_scope          = "compartment prod"

  policy_statement_templates = [
    "Allow {principal} to inspect compartments in tenancy",
    "Allow {principal} to read all-resources in {scope}"
  ]

  oci_principals = [
    {
      type                 = "user"
      name                 = "breakglass@example.com"
      identity_domain_name = "Default"
    },
    {
      type                 = "dynamic_group"
      name                 = "prod-workers"
      identity_domain_name = "Default"
    }
  ]
}
