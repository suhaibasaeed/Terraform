# Root/main.tf

module "networking" {
    source = "./networking"
    # Variables going into module
    vpc_cidr = "10.123.0.0/16"
}