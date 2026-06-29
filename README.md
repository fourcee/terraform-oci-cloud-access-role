# terraform-oci-cloud-access-role

A Terraform module for deploying OCI IAM policy assignments. This module creates a single OCI IAM policy from statement templates and expands those templates across group principals, OCI users, and OCI dynamic groups.

## Features

- Assign OCI policy statement templates to group principals
- Assign OCI policy statement templates to typed OCI users and dynamic groups
- Support for compartment-level or tenancy-level policy scopes
- Automatic expansion of policy templates across multiple principals

## Usage

See the [examples directory](./examples) for complete usage examples.

### Compartment-Level IAM Assignment

```hcl
module "iam_assignment" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "dev-access"
  policy_compartment_id = "ocid1.compartment.oc1..exampleid"
  policy_scope          = "compartment dev"

  policy_statement_templates = [
    "Allow group {group} to read all-resources in {scope}",
    "Allow group {group} to use instances in {scope}"
  ]

  group_principals = [
    "Developers",
    "Ops"
  ]
}
```

### Typed OCI Principal Assignment

```hcl
module "iam_assignment" {
  source = "github.com/fourcee/terraform-oci-cloud-access-role"

  policy_name           = "typed-principal-access"
  policy_compartment_id = "ocid1.tenancy.oc1..exampleid"
  policy_scope          = "tenancy"

  policy_statement_templates = [
    "Allow {principal} to read all-resources in {scope}"
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
| policy_name | OCI IAM policy name. | `string` | n/a | yes |
| policy_description | OCI IAM policy description. | `string` | `"Managed by Helix Cloud Access Roles"` | no |
| policy_freeform_tags | Freeform tags to apply to the OCI IAM policy. | `map(string)` | `{}` | no |
| policy_compartment_id | Compartment OCID where the OCI IAM policy is created. Use the tenancy OCID for tenancy-level policies. | `string` | n/a | yes |
| policy_scope | Scope text used to replace `{scope}` in policy statement templates, such as `compartment dev` or `tenancy`. | `string` | n/a | yes |
| policy_statement_templates | List of OCI policy statement templates to render. Use `{group}`, `{principal}`, and `{scope}` placeholders. | `list(string)` | n/a | yes |
| group_principals | List of OCI group names to assign policies to. | `list(string)` | `[]` | no |
| oci_principals | List of typed OCI principals to assign policies to. Supported types are `user` and `dynamic_group`. | <pre>list(object({<br>  type                 = string<br>  name                 = string<br>  identity_domain_name = string<br>}))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_id | OCID of the created OCI IAM policy |
| policy_statements | Rendered OCI IAM policy statements |

## Notes

- Use the tenancy OCID as `policy_compartment_id` for tenancy-level policies
- Policy statement templates use `{group}` as a placeholder that gets replaced with each group principal name
- Policy statement templates use `{principal}` as a placeholder for typed OCI principals. Users render as `user <identity_domain_name>/<name>` and dynamic groups render as `dynamic-group <identity_domain_name>/<name>`
- Group principals should be OCI group names (e.g., `Developers`), not OCIDs
- Policy statement templates should use full OCI policy syntax (e.g., `Allow group {group} to read all-resources in {scope}`)

## License

See the LICENSE file for details.
