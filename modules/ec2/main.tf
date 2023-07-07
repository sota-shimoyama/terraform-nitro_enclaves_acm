locals {
  az_cnt = length(var.az_names)
}

data "aws_ssm_parameter" "amzn2_latest" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-arm64-gp2"
}


#############################
# SecurityGroup
#############################
resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-ec2-sg"
  description = "${var.name}-ec2-sg"
  vpc_id      = var.vpc_id

  #SSH(22)のInbound通信を許可
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ec2-sg"
  }
}

##############################
# EC2 Instance
##############################
resource "aws_instance" "nitro" {
  ami                         = data.aws_ssm_parameter.amzn2_latest.value
  instance_type               = var.nitro_instance_type
  associate_public_ip_address = false
  subnet_id                   = var.subnet_public_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_pair_id
  user_data                   = filebase64("${path.module}/scripts/nitro_init.sh")

  enclave_options {
    enabled = true
  }

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
    tags = {
      Name = "${var.name}-nitro-ebs"
    }
  }

  tags = {
    Name = "${var.name}-nitro_instance"
  }
}
