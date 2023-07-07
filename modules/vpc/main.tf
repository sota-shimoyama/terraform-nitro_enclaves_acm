locals {
  az_cnt = length(var.az_names)
}

#########
# VPC
#########
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

##############################
# Public subnet 
##############################
resource "aws_subnet" "public" {

  #countに2が格納されている
  #countに格納されている数値文だけ繰り返す

  count  = local.az_cnt
  vpc_id = aws_vpc.this.id

  #countのindexの数だけ作成される(2個)
  cidr_block        = cidrsubnet(var.cidr_block, 8, 2 + count.index)
  availability_zone = var.az_names[count.index]

  tags = {
    Name = "${var.name}-subnet-public-${var.az_names[count.index]}"
  }
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

##################################
# Public routes 
##################################
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-route-public"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = local.az_cnt
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}

##############
# Elastic IP
##############
resource "aws_eip" "nitro" {
  instance = var.nitro_instance
  domain   = "vpc"

  tags = {
    Name = "${var.name}-nitro-elastic-ip"
  }
}
