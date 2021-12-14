# Root/main.tf

module "networking" {
  source = "./networking"
  # Variables going into module
  vpc_cidr        = local.vpc_cidr
  access_ip       = var.access_ip
  security_groups = local.security_groups
  # Ranges for public and private subnets using for loop, range and cidrsubnet
  public_cidrs  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  # Subnet counts so we don't deploy too many subnets
  private_sn_count = 3
  public_sn_count  = 2
  max_subnets      = 20

}
