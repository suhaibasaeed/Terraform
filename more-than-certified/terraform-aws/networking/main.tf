# Networking/main.tf

data "aws_availability_zones" "available" {}
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

resource "aws_subnet" "mtc_public_subnet" {
  # Changed to manual count
  count = var.public_sn_count
  # Reference VPC resource created earlier
  vpc_id = aws_vpc.mtc_vpc.id
  # Use list index
  cidr_block = var.public_cidrs[count.index]
  # Default is false
  map_public_ip_on_launch = true
  # list of AZs we're going to use - Use data source and it's name attribute
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    # Good practice to do + 1
    Name = "mtc_public-${count.index + 1}"
  }
}

resource "aws_subnet" "mtc_private_subnet" {
  # Changed to manual count
  count = var.private_sn_count
  # Reference VPC resource created earlier
  vpc_id = aws_vpc.mtc_vpc.id
  # Use list index
  cidr_block = var.private_cidrs[count.index]
  # list of AZs we're going to use - Use data source and it's name attribute
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    # Good practice to do + 1
    Name = "mtc_private-${count.index + 1}"
  }
}