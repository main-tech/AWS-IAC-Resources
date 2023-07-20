
# Infrastructure as Code (IAC) for EC2 Instance in Public VPC

This Terraform script provisions an EC2 instance in a public VPC.
Before running the deployment, follow these steps:

1. Copy the `secrets.template.tf` file to `secrets.tf`.
2. Fill in the required values in the `secrets.tf` file.
3. Initialize terraform ` terraform init `
4. Preview terraform plan ` terraform plan -var-file=secrets.tfvars `
5. Deploy infrastructure ` terraform apply -var-file=secrets.tfvars `
