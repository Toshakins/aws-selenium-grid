output "address" {
  value = "${aws_instance.selenium.public_ip}"
}