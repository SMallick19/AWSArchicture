output "vpc_id" {
  value = aws_vpc.cloudArc.id
}

output "public_subnet_ids" {
  value = aws_subnet.publicSubnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.privateSubnet[*].id
}