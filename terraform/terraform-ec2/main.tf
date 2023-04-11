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
region  = var.region_name
}

resource "aws_instance" "app_server" {
ami           = var.ami_id
instance_type = var.instance_type

tags = {
    Name = var.tag
}
}
