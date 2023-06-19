# terraform_project

1. main.tf file contains all the resource data and it is created on Windows base machine
2. All variable are listed in variable.tf
3. terraform.tfvars contains Access key & Secrete access key as I was getting issue while setting up it as an environmental variables
4. playbook.yaml contains the ansible code to deploy mediawiki app and secret.yaml contains the password of root user for database and wiki user.
5. to encrypt it as a vault you will need to run below command
> ansible-vault encrypt secret.yaml
> 
7. rhel7_server.pem is key to create a instance
