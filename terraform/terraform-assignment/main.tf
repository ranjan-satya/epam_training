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

module "webserver-network" {
  source = ".//network-module"
}

output "my_vpc_id" {
  value       = module.webserver-network.my_vpc_id
  description = "ID of my vpc"
}

output "web_subnet_1_id" {
  value       = module.webserver-network.web_subnet_1_id
  description = "ID of web-subnet-1"
}

output "web_subnet_2_id" {
  value       = module.webserver-network.web_subnet_2_id
  description = "ID of web-subnet-2"
}

output "app_subnet_1_id" {
  value       = module.webserver-network.app_subnet_1_id
  description = "ID of app-subnet-1"
}

output "app_subnet_2_id" {
  value       = module.webserver-network.app_subnet_2_id
  description = "ID of app-subnet-2"
}

output "db_subnet_1_id" {
  value       = module.webserver-network.db_subnet_1_id
  description = "ID of db-subnet-1"
}

output "db_subnet_2_id" {
  value       = module.webserver-network.db_subnet_2_id
  description = "ID of db-subnet-2"
}

output "web_sg_id" {
  value       = module.webserver-network.web_sg_id
  description = "ID of web-sg"
}

output "webserver_sg_id" {
  value       = module.webserver-network.webserver_sg_id
  description = "ID of webserver-sg"
}

output "database_sg_id" {
  value       = module.webserver-network.database_sg_id
  description = "ID of database-sg"
}

module "webserver-instance" {
  source = ".//instance-module"


  webserver_sg_id = module.webserver-network.webserver_sg_id
  web_subnet_1_id = module.webserver-network.web_subnet_1_id
  web_subnet_2_id = module.webserver-network.web_subnet_2_id
}

output "webserver1_id" {
  value       = module.webserver-instance.webserver1_id
  description = "ID of webserver1"
}

output "webserver2_id" {
  value       = module.webserver-instance.webserver2_id
  description = "ID of webserver2"
}

module "webserver-db" {
  source = ".//db-module"


  db_subnet_1_id = module.webserver-network.db_subnet_1_id
  db_subnet_2_id = module.webserver-network.db_subnet_2_id
  database_sg_id = module.webserver-network.database_sg_id
}

module "webserver-loadbalancer" {
  source = ".//loadbalancer-module"


  web_sg_id = module.webserver-network.web_sg_id
  web_subnet_1_id = module.webserver-network.web_subnet_1_id
  web_subnet_2_id = module.webserver-network.web_subnet_2_id
  my_vpc_id = module.webserver-network.my_vpc_id
  webserver1_id = module.webserver-instance.webserver1_id
  webserver2_id = module.webserver-instance.webserver2_id
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.webserver-loadbalancer.lb_dns_name
}

