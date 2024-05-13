variable "PUBLIC_KEY-aws" {
  description = "The public key content for the AWS key pair"

}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.49.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
resource "aws_key_pair" "deployer" {
  key_name   = "research-backend-key-pair"
  public_key =  var.PUBLIC_KEY-aws
}
