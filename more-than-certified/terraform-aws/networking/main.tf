# Networking/main.tf

data "aws_availability_zones" "available" {}

# Will be used for VPC
resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  # Use data source as input
  input = data.aws_availability_zones.available.names
  # Give us list length equal to max. no of subnets we specified.
  result_count = var.max_subnets
}

resource "aws_vpc" "mtc_vpc" {
  # Don't hardcode range as it's a module
  cidr_block = var.vpc_cidr
  # So that we can have DNS hostnames for resources in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mtc_vpc-${random_integer.random.id}"
  }

  # Create new VPC before old one is destroyed
  lifecycle {
    create_before_destroy = true
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
  # list of AZs we're going to use - Use random shuffle
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    # Good practice to do + 1
    Name = "mtc_public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "mtc_public_association" {
  # Every public subnet needs to be associated with public RT
  count = var.public_sn_count
  # Subnet IDs of all the public subnets
  subnet_id      = aws_subnet.mtc_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_subnet" "mtc_private_subnet" {
  # Changed to manual count
  count = var.private_sn_count
  # Reference VPC resource created earlier
  vpc_id = aws_vpc.mtc_vpc.id
  # Use list index
  cidr_block = var.private_cidrs[count.index]
  # list of AZs we're going to use - Use random shuffle
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    # Good practice to do + 1
    Name = "mtc_private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  # Reference VPC resource created earlier
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_public"
  }
}

resource "aws_route" "default_route" {
  # Specify which RT route is for
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  # What is the next hop i.e. gateway of last resort
  gateway_id = aws_internet_gateway.mtc_internet_gateway.id
}

# We'll be using this for the private subnets
resource "aws_default_route_table" "mtc_private_rt" {
  # Every VPC already gets default RT - We specify it's default for our infra
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id

  tags = {
    Name = "mtc_private"
  }
}

resource "aws_security_group" "mtc_sg" {
  # Use for each and reference key of map
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  # Use dynamic block as we could have multiple rules for each
  dynamic "ingress" {
    for_each = each.value.ingress
    content {

      # Reference key from locals block
      from_port = ingress.value.from
      to_port   = ingress.value.to
      protocol  = ingress.value.protocol
      # list of ranges allowed to access resources
      cidr_blocks = ingress.value.cidr_blocks
    }
  }


  # Outbound rules
  egress {
    from_port = 0
    to_port   = 0
    # -1 means all protocols
    protocol = "-1"
    # list of ranges allowed to access resources
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "mtc_rds_subnetgroup" {
  # If bool is true then set count to 1 - otherwise set to 0
  count = var.db_subnet_group == true ? 1 : 0
  name  = "mtc_rds_subnetgroup"
  # Specify subnets to add - we want to add all private subnets
  subnet_ids = aws_subnet.mtc_private_subnet.*.id

  tags = {
    Name = "mtc_rds_sng"
  }
}