// variable "region" {}
variable "owner" {}

# project name
variable "project" {}

# environment
variable "env" {
  type        = string
  description = "This variable defines the environment to be built"
}

# region
variable "region" {
    type = string
}

# region
# locals {
#     region-name = terraform.workspace == "dev" ? "Korea Central" : "Japan East"
# }