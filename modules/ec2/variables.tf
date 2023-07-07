variable "name" {
  type        = string
  description = "The module name"
}

variable "az_names" {
  type        = list(string)
  description = "The AZ names"
}

variable "subnet_public_ids" {
  type        = list(string)
  description = "The public subnet ids"
}

variable "sg_ingress_cidr_block" {
  type        = list(string)
  description = "The cidr block of security group"
}

variable "nitro_instance_type" {
  type        = string
  description = "The instance type of nitro EC2"
}

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "volume_type" {
  type        = string
  description = "The EC2 volume type."
}

variable "volume_size" {
  type        = number
  description = "The EC2 volume size."
}

variable "key_pair_id" {
  type        = string
  description = "The key pair id."
}

variable "nitro_elastic_ip" {
  type        = string
  description = "The Elastic IP"
}
