terraform {
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "TaskVPC"
  }
}

resource "aws_subnet" "web-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-1a"
  }
}

resource "aws_subnet" "web-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-2b"
  }
}

resource "aws_subnet" "app-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.1.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Application-1a"
  }
}

resource "aws_subnet" "app-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.1.5.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Application-2b"
  }
}

resource "aws_subnet" "db-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database-1a"
  }
}

resource "aws_subnet" "db-subnet-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.1.8.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database-2b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "TaskIGW"
  }
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.my-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "WebRT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.web-subnet-1.id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.web-subnet-2.id
  route_table_id = aws_route_table.web-rt.id
}


resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

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

resource "aws_security_group" "webserver-sg" {
  name        = "Webserver-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from web layer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver-SG"
  }
}

resource "aws_security_group" "database-sg" {
  name        = "Database-SG"
  description = "Allow inbound traffic from application layer"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SG"
  }
}

output "my_vpc_id" {
  value       = aws_vpc.my-vpc.id
  description = "ID of my vpc"
}

output "web_subnet_1_id" {
  value       = aws_subnet.web-subnet-1.id
  description = "ID of web-subnet-1"
}

output "web_subnet_2_id" {
  value       = aws_subnet.web-subnet-2.id
  description = "ID of web-subnet-2"
}

output "app_subnet_1_id" {
  value       = aws_subnet.app-subnet-1.id
  description = "ID of app-subnet-1"
}

output "app_subnet_2_id" {
  value       = aws_subnet.app-subnet-2.id
  description = "ID of app-subnet-2"
}

output "db_subnet_1_id" {
  value       = aws_subnet.db-subnet-1.id
  description = "ID of db-subnet-1"
}

output "db_subnet_2_id" {
  value       = aws_subnet.db-subnet-2.id
  description = "ID of db-subnet-2"
}

output "web_sg_id" {
  value       = aws_security_group.web-sg.id
  description = "ID of web-sg"
}

output "webserver_sg_id" {
  value       = aws_security_group.webserver-sg.id
  description = "ID of webserver-sg"
}

output "database_sg_id" {
  value       = aws_security_group.database-sg.id
  description = "ID of database-sg"
}