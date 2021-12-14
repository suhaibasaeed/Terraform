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
        ssh = {
          from     = 22
          to       = 22
          protocol = "tcp"
          # list of ranges allowed to access resources
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}