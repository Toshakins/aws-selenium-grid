# Selenium with Chrome

## Requirements
Terraform, Ansible


## Instructions

To run, configure your AWS provider as described in 

https://www.terraform.io/docs/providers/aws/index.html

Run with a command like this:

```
terraform apply -var 'key_name={your_aws_key_name}' \
   -var 'public_key_path={location_of_your_key_in_your_local_machine}'
```

For example:

```
terraform apply -var 'key_name=terraform' -var 'public_key_path=/Users/jsmith/.ssh/terraform.pub'
```

Otherwise, you can configure default `tfvars` and then just `./FIRST_RUN.sh`.
