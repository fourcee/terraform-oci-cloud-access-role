# Examples

This directory contains example configurations for using the OCI IAM Assignment Terraform module.

## Examples Overview

### 1. Compartment-Level IAM with Predefined Policies (`examples.tf` - Example 1)

Demonstrates assigning OCI predefined policy statements to group principals at the compartment level. This is the simplest use case.

**Use when:**
- You only need standard policy statements
- Working at the compartment level
- No custom policy grouping needed

### 2. Compartment-Level IAM with Custom Policies (`examples.tf` - Example 2)

Shows how to create and assign named custom policy groups with specific statements at the compartment level.

**Use when:**
- You need grouped policy statements for specific use cases
- Want to implement least-privilege access
- Working at the compartment level

### 3. Tenancy-Level IAM Assignment (`examples.tf` - Example 3)

Demonstrates IAM policy assignments at the tenancy level with both predefined and custom policies.

**Use when:**
- Managing permissions across the entire tenancy
- Need tenancy-wide policies
- Implementing hierarchical access control

### 4. Multiple Principals with Policies (`examples.tf` - Example 4)

Shows how multiple group principals can be assigned multiple policies efficiently.

**Use when:**
- Managing multiple teams with different access levels
- All groups need the same set of policies

## How to Use

1. Copy one of the examples to your Terraform configuration
2. Update the values:
   - `compartment_id` or `tenancy_id`
   - `predefined_policies` with your desired OCI policy statements
   - `custom_policies` with your custom policy definitions
   - `group_principals` with your OCI group names
3. Run `terraform init` and `terraform plan` to review changes
4. Apply with `terraform apply` when ready

## Notes

- All examples use the module source as `github.com/fourcee/terraform-oci-cloud-access-role`
- You may need to adjust this based on your module installation method
- Ensure you have appropriate OCI permissions to create policies
- Group principals should be OCI group names (not OCIDs)
- Policy statements use `{group}` as a placeholder that gets replaced with each group name
