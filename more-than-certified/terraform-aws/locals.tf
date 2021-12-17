locals {
  # So we can remove duplication below
  vpc_cidr = "10.123.0.0/16"
}

locals {
  # map for SGs
  security_groups = {
    public = {
      name        = "public_sg"
      description = "SG for public subnet"
      ingress = {
        open = {
          # All ports
          from = 0
          to   = 0
          # All protocols
          protocol = -1
          # list of ranges allowed to access resources
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        nginx = {
          from        = 8000
          to          = 8000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }

    rds = {
      name        = "rds_sg"
      description = "SG for private RDS"
      ingress = {
        mysql = {
          from     = 3306
          to       = 3306
          protocol = "tcp"
          # We only want access from within the VPC
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}