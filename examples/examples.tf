# Example configurations for the OCI IAM Assignment Module

# Example 1: Compartment-level IAM assignment with predefined policies only
module "compartment_iam_predefined" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  predefined_policies = [
    "Allow group {group} to read all-resources in compartment dev",
    "Allow group {group} to use instances in compartment dev",
    "Allow group {group} to read objects in compartment dev"
  ]

  group_principals = [
    "Developers",
    "Analysts"
  ]
}

# Example 2: Compartment-level IAM assignment with custom policies
module "compartment_iam_custom" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  predefined_policies = [
    "Allow group {group} to read all-resources in compartment dev"
  ]

  custom_policies = [
    {
      name        = "custom-app-policy"
      description = "Custom policy for application-specific permissions"
      statements = [
        "Allow group {group} to manage objects in compartment dev where target.bucket.name='app-data'",
        "Allow group {group} to use instances in compartment dev",
        "Allow group {group} to manage load-balancers in compartment dev"
      ]
    },
    {
      name        = "custom-data-policy"
      description = "Custom policy for data access"
      statements = [
        "Allow group {group} to read autonomous-databases in compartment dev",
        "Allow group {group} to use database-connections in compartment dev"
      ]
    }
  ]

  group_principals = [
    "AppUsers"
  ]
}

# Example 3: Tenancy-level IAM assignment
module "tenancy_iam_assignment" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  tenancy_id = "ocid1.tenancy.oc1..exampletenancyid"

  predefined_policies = [
    "Allow group {group} to inspect compartments in tenancy",
    "Allow group {group} to read all-resources in tenancy"
  ]

  custom_policies = [
    {
      name        = "tenancy-admin-policy"
      description = "Custom policy for tenancy-level administration"
      statements = [
        "Allow group {group} to manage compartments in tenancy",
        "Allow group {group} to manage policies in tenancy"
      ]
    }
  ]

  group_principals = [
    "TenancyAdmins",
    "ProjectViewers"
  ]
}

# Example 4: Multiple principals with different policies
# NOTE: This example demonstrates the Cartesian product behavior where ALL principals
# receive ALL policies. In this case, all three groups will receive all policy statements.
# For production use, consider creating separate module calls for different access levels.
module "multi_principal_iam" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  # WARNING: manage all-resources grants full administrative access. Use sparingly and only for trusted admins.
  # Consider using more restricted policy statements with specific resource types.
  predefined_policies = [
    "Allow group {group} to read all-resources in compartment prod",
    "Allow group {group} to use all-resources in compartment prod",
    "Allow group {group} to manage all-resources in compartment prod"
  ]

  group_principals = [
    "Viewers",
    "Editors",
    "Admins"
  ]
}

# Example 5: Different policies for different groups (recommended approach)
# Create separate module calls to assign different policies to different groups
module "viewer_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  predefined_policies = [
    "Allow group {group} to read all-resources in compartment prod"
  ]

  group_principals = [
    "Viewers"
  ]
}

module "editor_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  predefined_policies = [
    "Allow group {group} to read all-resources in compartment prod",
    "Allow group {group} to use all-resources in compartment prod"
  ]

  group_principals = [
    "Editors"
  ]
}

module "admin_access" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..examplecompartmentid"

  # WARNING: manage all-resources grants full administrative access. Use sparingly.
  predefined_policies = [
    "Allow group {group} to read all-resources in compartment prod",
    "Allow group {group} to use all-resources in compartment prod",
    "Allow group {group} to manage all-resources in compartment prod"
  ]

  group_principals = [
    "Admins"
  ]
}
