
# Define provider and region
provider "aws" {
  region = "us-east-1"
}

# Input variables
variable "directory_password" {
  description = "Password for AWS Microsoft AD directory"
}

# Create VPC
resource "aws_vpc" "active_directory_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC for AWS Microsoft AD"
  }
}

# Create first subnet in the first availability zone
resource "aws_subnet" "active_directory_subnet1" {
  vpc_id            = aws_vpc.active_directory_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet 1 for AWS Microsoft AD"
  }
}

# Create second subnet in the second availability zone
resource "aws_subnet" "active_directory_subnet2" {
  vpc_id            = aws_vpc.active_directory_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subnet 2 for AWS Microsoft AD"
  }
}

# Create AWS Microsoft AD directory
resource "aws_directory_service_directory" "active_directory" {
  name     = "icipe.org"
  password = var.directory_password
  size     = "Small"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.active_directory_vpc.id
    subnet_ids = [aws_subnet.active_directory_subnet1.id, aws_subnet.active_directory_subnet2.id]
  }

  tags = {
    Name = "AWS Microsoft AD Directory"
  }
}

# Output the AWS Microsoft AD directory DNS addresses
output "directory_dns_addresses" {
  value = aws_directory_service_directory.active_directory.dns_ip_addresses
}
