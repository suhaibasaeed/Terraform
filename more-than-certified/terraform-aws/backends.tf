terraform {
  backend "remote" {
    organization = "Suhaib-mtc-terraform"

    workspaces {
      name = "mtc-dev"
    }
  }
}
