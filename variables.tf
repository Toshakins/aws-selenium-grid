variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-central-1"
}

# Ubuntu 16.04 LTS (x64)
variable "aws_amis" {
  type = "map"
  default = {
    "eu-central-1"  = "ami-5055cd3f"
  }
}

variable "subnet_id" {
  description = "Subnet ID to assign to the EC2 instance"
}

variable "vpc_id" {
  description = "VPC ID to assisng to the EC2 instance"
}