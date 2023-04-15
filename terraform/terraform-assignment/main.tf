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

module "webserver-instance" {
  source = ".//instance-module"

  webserver_sg_id = module.webserver-network.webserver_sg_id
  web_subnet_1_id = module.webserver-network.web_subnet_1_id
  web_subnet_2_id = module.webserver-network.web_subnet_2_id
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

