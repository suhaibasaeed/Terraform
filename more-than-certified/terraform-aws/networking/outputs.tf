# networking/outputs.tf

output "vpc_id" {
    # Other resources ref the ID
    value = aws_vpc.mtc_vpc.id
}