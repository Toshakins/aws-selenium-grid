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

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  type = "map"
  default = {
    "eu-west-1"     = "ami-674cbc1e"
    "us-east-1"     = "ami-1d4e7a66"
    "us-west-1"     = "ami-969ab1f6"
    "us-west-2"     = "ami-8803e0f0"
    "eu-central-1"  = "ami-5055cd3f"
  }
}

variable "security_group" {
  description = "Security Group to assign to EC2 instance"
}

variable "subnet_id" {
  description = "Subnet ID to assign to the EC2 instance"
}