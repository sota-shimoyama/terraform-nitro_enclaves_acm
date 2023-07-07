###########
# Provider
###########
terraform {
  required_version = ">= 1.2.6"
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}

##################
# Local Variables
##################
locals {
  az_names = slice(data.aws_availability_zones.available.names, 0, var.az_cnt)
  name     = "${var.project}-${var.env}"
}

#################
# Avaiable Zones
#################
data "aws_availability_zones" "available" {
  state = "available"
}

#########
# VPC
#########
module "vpc" {
  source = "./modules/vpc"

  name           = local.name
  cidr_block     = var.vpc_cidr_block
  az_names       = local.az_names
  nitro_instance = module.ec2.nitro_instance_id
}

##############
# EC2
##############
module "ec2" {
  source = "./modules/ec2"

  name                  = local.name
  subnet_public_ids     = module.vpc.subnet_public_ids
  nitro_instance_type   = var.nitro_instance_type
  az_names              = local.az_names
  vpc_id                = module.vpc.vpc_id
  sg_ingress_cidr_block = var.sg_ingress_cidr_block
  volume_type           = var.volume_type
  volume_size           = var.volume_size
  key_pair_id           = var.key_pair_id
  nitro_elastic_ip      = module.vpc.nitro_elastic_ip
}
