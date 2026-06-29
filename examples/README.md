# Examples

This directory contains example configurations for using the OCI IAM Assignment Terraform module.

## Examples Overview

### 1. Compartment-Level Group Access

Demonstrates assigning OCI policy statement templates to group principals at the compartment level.

Use when:
- You are granting access to OCI groups
- Your statements use the `Allow group {group} ...` syntax
- All listed groups should receive the same rendered statements

### 2. Compartment-Level Typed Principal Access

Shows how to assign policy statement templates to individual OCI users and dynamic groups.

Use when:
- You are granting access to OCI users or dynamic groups
- Your statements use the `Allow {principal} ...` syntax
- The module should render `user <identity_domain_name>/<name>` and `dynamic-group <identity_domain_name>/<name>`

### 3. Tenancy-Level Dynamic Group Access

Demonstrates tenancy-scoped policy statements for a dynamic group.

Use when:
- The policy should be created in the tenancy compartment
- The policy scope is `tenancy`
- A dynamic group needs tenancy-wide read or inspect permissions

### 4. Multiple Typed Principals

Shows how multiple typed principals can receive the same policy statement templates.

Use when:
- Multiple OCI users or dynamic groups need the same access
- The policy statement templates are valid for every typed principal in the module call

## How to Use

1. Copy one of the examples to your Terraform configuration
2. Update the values:
   - `policy_name`
   - `policy_compartment_id`
   - `policy_scope`
   - `policy_statement_templates`
   - `group_principals` or `oci_principals`
3. Run `terraform init` and `terraform plan` to review changes
4. Apply with `terraform apply` when ready

## Notes

- All examples use the module source as `github.com/fourcee/terraform-oci-cloud-access-role`
- You may need to adjust this based on your module installation method
- Ensure you have appropriate OCI permissions to create policies
- Group principals should be OCI group names, not OCIDs
- Group policy statements use `{group}` as a placeholder that gets replaced with each group name
- Typed-principal policy statements use `{principal}` as a placeholder that gets replaced with an OCI user or dynamic-group subject
- Keep group templates and typed-principal templates in separate module calls unless every template is valid for every configured principal
