# Networking/main.tf

# Will be used for VPC
resource "random_integer" "random" {
    min =  1
    max = 100
}

resource "aws_vpc" "mtc_vpc" {
    # Don't hardcode range as it's a module
    cidr_block = 
}