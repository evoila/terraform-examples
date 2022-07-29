# The glory of variables

Terraform is an awesome tool to use the same code with different variables to create objects of the same type but with different configuration. This example shows how you can use one configuration file to create different environments (like DEV / TEST / PROD).
(Important: Here we use one configuration file for multiple environments. Of course you could also use different pipelines for this case. Then you would use configuration and environments would be grouped through different pipelines)

## Setup

1. Check that the t1 routers t1-terraform-demo-dev, t1-terraform-demo-prod and the switches ls-terraform-demo-dev-sw1, ls-terraform-demo-dev-sw2 sowie ls-terraform-demo-prod-sw1 do not exist.

## Execution

1. terraform init
2. Transform the YAML config into json (Would be a task in a pipeline)
    - yq . variables.yaml -o json > variables.json
3. terraform plan -var-file variables.json
    - Here terraform will display some resources. (~15 Stück)
4. terraform apply -var-file variables.json
5. Take a look at the create T1 routers and switches in NSX-T 
6. Want another environment? Add the necessary configuration to variables.yaml

```yaml
test:
    switches:
    - name: ls-terraform-demo-test-sw1
      cidr: 4.4.4.1/24
```

7. Repeat step 2
8. terraform plan -var-file variables.json
    - Terraform only displays the resources, which it creates for the new environment. 
9. terraform apply -var-file variables.json
10. Take a look at NSX-T again. Terraform created some new switches.

## Cleanup

1. terraform destroy -var-file variables.json

## What did we lean?

Terraform is a powerful tool, when you use variables. Write Code once - Use it in different environments!