terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "ca3-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "ca3VPC"
  }
}

resource "aws_subnet" "ca3-subnet-1" {
  vpc_id                  = aws_vpc.ca3-vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ca3-subnet-1a"
  }
}

resource "aws_subnet" "ca3-subnet-2" {
  vpc_id                  = aws_vpc.ca3-vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ca3-subnet-1b"
  }
}

resource "aws_internet_gateway" "ca3igw" {
  vpc_id = aws_vpc.ca3-vpc.id

  tags = {
    Name = "ca3IGW"
  }
}

resource "aws_route_table" "ca3-rt" {
  vpc_id = aws_vpc.ca3-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ca3igw.id
  }

  tags = {
    Name = "ca3RT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.ca3-subnet-1.id
  route_table_id = aws_route_table.ca3-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.ca3-subnet-2.id
  route_table_id = aws_route_table.ca3-rt.id
}


resource "aws_security_group" "ca3-sg" {
  name        = "ca3-SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.ca3-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
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
    Name = "Web-SG"
  }
}


resource "aws_instance" "ca3webserver1" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.ca3-sg.id]
  subnet_id              = aws_subnet.ca3-subnet-1.id
  user_data              = file("./install_http.sh")

  tags = {
    Name = "CA3 Web Server 1"
  }

}
resource "aws_instance" "ca3webserver2" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.ca3-sg.id]
  subnet_id              = aws_subnet.ca3-subnet-2.id
  user_data              = file("./install_http2.sh")

  tags = {
    Name = "CA3 Web Server 2"
  }

}

resource "aws_lb" "external-elb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ca3-sg.id]
  subnets            = [aws_subnet.ca3-subnet-1.id, aws_subnet.ca3-subnet-2.id]
}

resource "aws_lb_target_group" "external-elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ca3-vpc.id
}

resource "aws_lb_target_group_attachment" "external-elb1" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.ca3webserver1.id
  port             = 80

  depends_on = [
    aws_instance.ca3webserver1,
  ]
}

resource "aws_lb_target_group_attachment" "external-elb2" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.ca3webserver2.id
  port             = 80

  depends_on = [
    aws_instance.ca3webserver2,
  ]
}

resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-elb.arn
  }
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.external-elb.dns_name
}

