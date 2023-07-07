output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of VPC"
}

output "subnet_public_ids" {
  value       = aws_subnet.public[*].id
  description = "The IDs of public subnets"
}

output "nitro_elastic_ip" {
  value       = aws_eip.nitro.public_ip
  description = "Elastic IP"
}
