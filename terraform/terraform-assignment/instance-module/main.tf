terraform {
  required_version = ">= 1.2.0"
}

resource "aws_instance" "webserver1" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [var.webserver_sg_id]
  subnet_id              = var.web_subnet_1_id
  user_data              = file("./install_http.sh")

  tags = {
    Name = "Web Server-1"
  }

}

resource "aws_instance" "webserver2" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [var.webserver_sg_id]
  subnet_id              = var.web_subnet_2_id
  user_data              = file("./install_http.sh")

  tags = {
    Name = "Web Server-2"
  }

}

output "webserver1_id" {
  value       = aws_instance.webserver1.id
  description = "ID of webserver1"
}

output "webserver2_id" {
  value       = aws_instance.webserver2.id
  description = "ID of webserver2"
}