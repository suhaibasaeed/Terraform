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
  # We want a db subnet group
  db_subnet_group = true

}

# module "database" {
#   source = "./database"
#   # In GiB - 1024MB
#   db_storage        = 10
#   db_engine_version = "5.7.22"
#   db_instance_class = "db.t2.micro"
#   dbname            = var.dbname
#   dbuser            = var.dbuser
#   dbpassword        = var.dbpassword
#   db_identifier     = "mtc-db"
#   skip_db_snapshot  = true
#   # There's only one group name
#   db_subnet_group_name   = module.networking.db_subnet_group_name[0]
#   vpc_security_group_ids = module.networking.db_security_group
# }

module "loadbalancing" {
  source         = "./loadbalancing"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  tg_port        = 8000
  tg_protocol    = "HTTP"
  vpc_id         = module.networking.vpc_id
  # seconds{}
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 8000
  listener_protocol      = "HTTP"
}

module "compute" {
  source         = "./compute"
  instance_count = 1
  instance_type  = "t3.micro"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  vol_size       = 10
  key_name = "mtckey"
  public_key_path = "/home/ubuntu/.ssh/keymtc.pub"
}