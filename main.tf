# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "selenium" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create a VPC to launch our instance into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instance into
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "selenium" {
  name   = "Selenium Grid"
  vpc_id = aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elastic IP for EC2 instance
resource "aws_eip" "ip" {
  instance = aws_instance.selenium.id
}

resource "aws_instance" "selenium" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    # The default username for our AMI
    user = "ubuntu"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = var.aws_amis[var.aws_region]

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.selenium.id

  # The name of the instance
  tags = {
    Name = "selenium"
  }

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.selenium.id]

  subnet_id = aws_subnet.default.id

  # install Ansible requirements
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install -y python-minimal python-apt python-pip",
    ]
  }

  # Prepare hosts file for Ansible
  provisioner "local-exec" {
    command = "echo ${aws_instance.selenium.public_ip} > ip_address.txt"
  }

  # Run Ansible 😎
  provisioner "local-exec" {
    command = "ansible-playbook -i ip_address.txt -u ubuntu provision.yml"
  }
}
