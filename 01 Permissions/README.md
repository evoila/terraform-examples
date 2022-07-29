# Permissions

This example should show, why it is important to start automation of vCenter permissions on day 0.
If you don't start automation of permissions on day 0 some unexpected things could happen (loss of permissions etc.)

## Setup

1. Create the resource pool terraform-permission-demo in vCenter by hand.
2. Select the resource pool, change into the permissions tab and set permissions for a random user on the resource pool. (Caution: Do not use the terraform demo user here)

## Execution

1. terraform init
2. terraform plan
    - Here terraform should only display the permissions, which are set by the terraform file.
3. terraform apply
4. Take a look at the vCenter permissions tab again. Both permissions should be set.
5. terraform plan
    - Here terrafrom suddenly want's to delete the permission, which was created by hand
6. terraform apply
7. Take a look at the vCenter again. You will notice, that the permission, which was created by hand is gone.
   -> If you are not careful enough unexpected side effects could happen (like loosing permissions).

## Cleanup

1. Delete the created resource pool in vCenter.

## Started by hand?

If you started to set permissions by hand all permissions on the specific object have to be transfered to terraform.
Terraform does not support import functionaliy for permissions. All permissions have to be transfered, else permission loss could happen (This is a big problem on the vCenter / cluster layer)