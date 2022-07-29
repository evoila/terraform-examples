# 404 Option not found

This example shows, that terraform does not support all configuration parameters of some resources. For this cases you have to think for something else.

## Setup

1. Check, that the http application profile terraform-demo-application-profile does not exist. 

## Execution

1. terraform init
2. terraform plan
    - Displays, that an application profile will be created.
3. terraform apply
4. Check that the http profile exist via API.
    - `cat terraform.tfstate | jq -r '.resources[].instances[0].attributes.id' | xargs -I % curl -u "$NSXT_USERNAME:$NSXT_PASSWORD" -k https://$NSXT_MANAGER_HOST/api/v1/loadbalancer/application-profiles/% | jq .`
    - The shown object does show some configuration parameters, which terraform does not know and thus does not support. For example: Response Body Size. For some applications this value has to be increased. This is a problem for terraform.

5. There are two options to solve this problem. Either you have to create the object externally (without terraform) and import the resource as data resource (This is often not possible, because some attributes are still missing or for some resources there does not exist a data resource) or you could create the object via terraform and modify the object via a following script.
6. In this example we decided to use a script. The script modifies the response header size accordingly and updates the nsx-t resource via API
    - Execute the script ./update-object.sh
7. Check with the command of step 4, that the response header size changed.
8. terraform plan
    - Does not display any changes, because terraform does not know this parameter. 
9. Change the terraform configuration (change request header size to 2048)
10. terraform plan
    - Only displays the request header size change
11. terraform apply
12. Execute command of step 4 again
    - Terraform changed the property back to its default value
    -> You have to execute the script after every terraform apply (which modifies the resource). In a pipeline you would execute the script in a step / job after terraform apply

## Cleanup

1. terraform destroy

## What did we lean?

Terraform does not support all objects respectively it's properties. This it it necessary to find some workarounds and on the same time create a support ticket, so the developer maybe can add the property in a following release.
The workarounds can be either:
- Completly create the object outside terraform via the api
    - Import the object with terraform import afterwards, if the provider supports it.
    - Disadvantage: Not all terraform resource have a data resource and thus can not be used in terraform
- Modification with a script after terraform apply:
    - Modify the property via script
    - Disadvantage: Has to be run after every terraform apply, which modifies the object
    - Disadvantage: The configuration could be wrong for a short amount of time (the time between terraform apply and the execution of the script.)

Nevertheless you should still not consider creating resources by hand, because it creates overhead, when you have to recreate the environment.