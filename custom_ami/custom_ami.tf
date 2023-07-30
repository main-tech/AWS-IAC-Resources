
provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

variable "source_instance_id" {
  type = string
}

resource "aws_ami_from_instance" "genomics_ami" {
  name               = "Genomics ami"
  description        = "this ami is preinstalled with repeat modeller and repeat masker"
  source_instance_id = var.source_instance_id
}

output "new_ami_id" {
  value = aws_ami_from_instance.genomics_ami.id
}

