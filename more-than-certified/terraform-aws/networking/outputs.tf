# networking/outputs.tf

output "vpc_id" {
  # Other resources ref the ID
  value = aws_vpc.mtc_vpc.id
}

output "db_subnet_group_name" {
  # Access all subnet groups name
  value = aws_db_subnet_group.mtc_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.mtc_sg["rds"].id]

}

output "public_sg" {
  value = aws_security_group.mtc_sg["public"].id
}
# All public subnets
output "public_subnets" {
  value = aws_subnet.mtc_public_subnet.*.id
}