terraform {
  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias   = "east"
  region  = "us-east-1"
}

module "dev" {
  source = "../../"

  # prj
  project_name = var.project_name
  environment = var.environment

  # VPC
  cidr_vpc = var.cidr_vpc
  cidr_public1 = var.cidr_public1
  cidr_public2 = var.cidr_public2
  cidr_public3 = var.cidr_public3
  cidr_public4 = var.cidr_public4
  cidr_private1 = var.cidr_private1
  cidr_private2 = var.cidr_private2
  cidr_private3 = var.cidr_private3
  cidr_private4 = var.cidr_private4

  # Public EC2
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  bastion_key_name      = var.bastion_key_name
  bastion_volume_size   = var.bastion_volume_size

  # Private EC2
  Private_EC2_ami           = var.Private_EC2_ami
  Private_EC2_instance_type = var.Private_EC2_instance_type
  Private_EC2_key_name      = var.Private_EC2_key_name
  Private_EC2_volume_size   = var.Private_EC2_volume_size

  # Private EC2-2
  Private_EC2_2_ami           = var.Private_EC2_2_ami
  Private_EC2_2_instance_type = var.Private_EC2_2_instance_type
  Private_EC2_2_key_name      = var.Private_EC2_2_key_name
  Private_EC2_2_volume_size   = var.Private_EC2_2_volume_size
  
}

module "cf" {
  source = "../../cf/"
  providers = {
    aws = aws.east
  }

  web_alb_arn = module.dev.web_alb_arn
  web_alb = module.dev.web_alb
  lb_domain_name = module.dev.lb_domain_name
  
  cf_domain = var.cf_domain
  project_name = var.project_name
  environment = var.environment
}