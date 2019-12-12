provider "aws" {
  region  = var.region
  profile = var.profile
}

module "resources" {
  source = "./modules"
}
