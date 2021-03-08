terraform {
  backend "remote" {
    organization = "Wolf"

    workspaces {
      name = "module-management-aws"
    }
  }
}
