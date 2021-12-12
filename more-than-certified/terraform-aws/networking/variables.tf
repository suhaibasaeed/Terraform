# Networking/variables.tf

variable "vpc_cidr" {
  type = string
}
variable "public_cidrs" {
  type = list
}
variable "private_cidrs" {
  type = list
}
variable "private_sn_count" {}
variable "public_sn_count" {}
