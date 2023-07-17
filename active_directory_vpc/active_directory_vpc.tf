# Define provider and region
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "active_directory_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC for AWS Managed Microsoft AD"
  }
}

# Create first subnet in the first availability zone
resource "aws_subnet" "active_directory_subnet1" {
  vpc_id            = aws_vpc.active_directory_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet 1 for AWS Managed Microsoft AD"
  }
}

# Create second subnet in the second availability zone
resource "aws_subnet" "active_directory_subnet2" {
  vpc_id            = aws_vpc.active_directory_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subnet 2 for AWS Managed Microsoft AD"
  }
}

# Create a route table for the subnets
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.active_directory_vpc.id

  tags = {
    Name = "Route Table for AWS Managed Microsoft AD"
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.active_directory_subnet1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.active_directory_subnet2.id
  route_table_id = aws_route_table.route_table.id
}

