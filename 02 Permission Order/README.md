# Permission Order

This example should show, why for some terraform resources it is important to watch out for the order for "inner" objects, since otherwise changes could happen, when applying the terraform configuration.

We use vSphere permissions here for example. These have to be orderer alphabetically.
(This example is not good in newer terraform versions. In earlier versions terraform showed changes for every plan. Maybe it's a good example that some strange plans still could do the right things)

## Setup

1. Check, that the resource pool terraform-permission-order-demo does not exist.

## Execution

1. terraform init
2. terraform plan
    - Here terraform displays, that it will create a RP and permissions on this RP.
3. terraform apply
4. Take a look at the resource pool in vCenter. Watch the permissions tab, which permissions terraform created. (This object and its children).
5. Add new permissions to the entity permission object (at the end of the object)

```hcl
permissions {
    user_or_group = "vsphere.local\\mdima"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.administrator.id
}
```

5. terraform plan
    - Here terraform shows, that it will add a new permission. But: Terraform also displays, that other permissions will be changed (because the users are not ordered alphabetically)
6. Sort the permissions (mdima -> nfeldhausen -> sbaier -> terraform-demo)
7. terraform plan
    - Displays a similar output as in step 5, but if you add an user whicht starts with z for example afterwards terraform will not display these strange changes.

## Cleanup

1. terraform destroy