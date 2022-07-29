# Allow Modifications

This example should show, how to tell terraform how to ignore specific changes to the infrastructure. This is the case, when other systems modify an object (e.g. bosh director and nsgroups).

## Setup

1. Check, that the nsgroup terraform-nsgroup-demo does not exist in NSX-T.

## Execution

1. terraform init
2. terraform plan
    - Terraform displays, that it will create a new nsgroup.
3. terraform apply
4. Take a look in NSX-T. Check that the nsgroup was created.
5. Manually add a member to the nsgroup via gui (some logical port for example)
6. terraform plan
    - Here terraform shows, that it will delete the member again.
7. terraform apply
8. Take a look at the nsgroup again. The group should be empty again.
9. Extend the nsgroup with the following code:

```hcl
lifecycle {
    ignore_changes = [
      member
    ]
}
```

10. Manually add a member to the nsgroup again
11. terraform plan
    - Here terraform should display "No changes."
12. Other modifications to the nsgroup are still possible via terraform (change the name for example)
13. terraform plan
    - Displays, that it want's to change the nsgroup name
14. terraform apply
15. Take a look at the nsgroup again. The name of the nsgroup should have changed.

## Cleanup

1. terraform destroy