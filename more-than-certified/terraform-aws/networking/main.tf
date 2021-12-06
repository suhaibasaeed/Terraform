# Networking/main.tf

# Will be used for VPC
resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mtc_vpc" {
  # Don't hardcode range as it's a module
  cidr_block = var.vpc_cidr
  # So that we can have DNS hostnames for resources in VPC
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "mtc_vpc-${random_integer.random.id}"
  }
}
