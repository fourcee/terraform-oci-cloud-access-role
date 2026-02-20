# terraform-oci-cloud-access-role

A Terraform module for deploying OCI IAM policy assignments. This module allows you to create IAM policies and assign both predefined and custom policy statements to group principals at either the compartment or tenancy level.

## Features

- Assign predefined OCI policy statements to group principals
- Create named custom policy groups with specific statements
- Support for both compartment-level and tenancy-level IAM assignments
- Automatic expansion of policy templates across multiple groups

## Usage

See the [examples directory](./examples) for complete usage examples.

### Compartment-Level IAM Assignment

```hcl
module "iam_assignment" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  compartment_id = "ocid1.compartment.oc1..exampleid"

  predefined_policies = [
    "Allow group {group} to read all-resources in compartment dev",
    "Allow group {group} to use instances in compartment dev"
  ]

  custom_policies = [
    {
      name        = "custom-app-policy"
      description = "Custom policy for application-specific permissions"
      statements = [
        "Allow group {group} to manage objects in compartment dev where target.bucket.name='app-data'",
        "Allow group {group} to manage load-balancers in compartment dev"
      ]
    }
  ]

  group_principals = [
    "Developers",
    "Ops"
  ]
}
```

### Tenancy-Level IAM Assignment

```hcl
module "iam_assignment" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  tenancy_id = "ocid1.tenancy.oc1..exampleid"

  predefined_policies = [
    "Allow group {group} to inspect compartments in tenancy"
  ]

  custom_policies = [
    {
      name        = "tenancy-custom-policy"
      description = "Custom policy for tenancy-level permissions"
      statements = [
        "Allow group {group} to manage compartments in tenancy",
        "Allow group {group} to manage policies in tenancy"
      ]
    }
  ]

  group_principals = [
    "TenancyAdmins"
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| oci | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| oci | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| predefined_policies | List of OCI policy statement templates to assign. Use {group} as placeholder. | `list(string)` | `[]` | no |
| custom_policies | List of custom OCI policy groups to create and assign | <pre>list(object({<br>  name        = string<br>  description = string<br>  statements  = list(string)<br>}))</pre> | `[]` | no |
| group_principals | List of OCI group names to assign policies to | `list(string)` | `[]` | no |
| compartment_id | The OCI compartment OCID to assign policies at. Must provide either compartment_id or tenancy_id. | `string` | `null` | no |
| tenancy_id | The OCI tenancy OCID to assign policies at. Must provide either compartment_id or tenancy_id. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_ids | Map of policy keys to their OCIDs |
| policy_names | Map of policy keys to their names |
| assigned_policies | List of all policy statement templates that have been assigned |
| assigned_principals | List of all principals that have been assigned policies |

## Notes

- You must provide either `compartment_id` or `tenancy_id`, but not both
- Policy statement templates use `{group}` as a placeholder that gets replaced with each group principal name
- Group principals should be OCI group names (e.g., `Developers`), not OCIDs
- Predefined policies should use full OCI policy syntax (e.g., `Allow group {group} to read all-resources in compartment dev`)

## License

See the LICENSE file for details.
