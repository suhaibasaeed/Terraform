# database/main.tf

resource "aws_db_instance" "mtc_db" {
  # In GiB
  allocated_storage = var.db_storage
  engine            = "mysql"
  engine_version    = var.db_engine_version
  # size of instance used
  instance_class = var.db_instance_class
  name           = var.dbname
  username       = var.dbuser
  password       = var.dbpassword
  # From networking module
  db_subnet_group_name = var.db_subnet_group_name
  # Also from networking module
  vpc_security_group_ids = var.vpc_security_group_ids
  identifier             = var.db_identifier
  # boolean
  skip_final_snapshot = var.skip_db_snapshot

  tags = {
    Name = "mtc_db"
  }
}