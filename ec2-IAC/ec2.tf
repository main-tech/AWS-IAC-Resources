
# Input variables
variable "existing_key_pair1" {
  description = "Key pair for EC2"
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "availability_zone" {
  type = string
}

# Define provider and region
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "server_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "server"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.server_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "Public Subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.server_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Create route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.server_vpc.id

  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Associate public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create default route in the public route table to route internet traffic through the internet gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create the security group for  Server
resource "aws_security_group" "ec2_security_group" {
  name        = "SecurityGroup"
  vpc_id      = aws_vpc.server_vpc.id
  description = "Security group for  Server"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = " Security Group"
  }
}

# Retrieve information about the existing key pairs
data "aws_key_pair" "key_pair1" {
  key_name = var.existing_key_pair1
}

# Create the EC2 instance in the public subnet
resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.existing_key_pair1
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "ec2_instacne"
  }
}
# Assign Elastic IP address to the EC2 instance
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2.id
}
