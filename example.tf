provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "selenium" {
  ami = "ami-5055cd3f"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.auth.id}"

  tags {
    Name = "${var.name}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "wget -c http://selenium-release.storage.googleapis.com/3.8/selenium-server-standalone-3.8.0.jar"
    ]

    connection {
      user = "ubuntu"
    }
  }
}