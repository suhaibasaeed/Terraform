# Root/main.tf

module "networking" {
    source = "./networking"
    # Variables going into module
    vpc_cidr = "10.123.0.0/16"
    # Ranges for public and private subnets using for loop, range and cidrsubnet
    public_cidrs = [for i in range(2,255,2) : cidrsubnet("10.123.0.0/16", 8, i)]
    private_cidrs = [for i in range(1,255,2) : cidrsubnet("10.123.0.0/16", 8, i)]
    # Subnet counts so we don't deploy too many subnets
    private_sn_count = 3
    public_sn_count = 2
}
