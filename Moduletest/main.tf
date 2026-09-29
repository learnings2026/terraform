# ROOT MODULE: this is the "orchestrator". It contains no AWS resources
# itself - it only calls child modules and wires their inputs/outputs together.

module "networking" {
  source = "./modules/networking" # LOCAL path source

  name                = "${var.project_name}-${var.environment}"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "compute" {
  source = "./modules/compute"

  name            = "${var.project_name}-${var.environment}"
  create_instance = var.create_instance
  instance_type   = var.instance_type

  # MODULE-TO-MODULE COMMUNICATION:
  # compute never talks to networking directly. The ROOT reads networking's
  # OUTPUTS and passes them as compute's INPUT variables.
  subnet_id           = module.networking.public_subnet_ids[0]
  security_group_ids  = [module.networking.security_group_id]
  associate_public_ip = var.associate_public_ip
}

# REUSABILITY: the same storage module called twice = two independent buckets.
module "app_bucket" {
  source = "./modules/storage"
  name   = "${var.project_name}-${var.environment}-app"
}

module "logs_bucket" {
  source = "./modules/storage"
  name   = "${var.project_name}-${var.environment}-logs"
}

# ---------------------------------------------------------------------------
# LATER EXAMPLES (do not uncomment until you finish the local-module labs)
#
# 1) Public Terraform Registry module with VERSION pinning:
# module "vpc_from_registry" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 5.0"          # allows 5.x, blocks 6.0
#   ...
# }
#
# 2) Your own module from GitHub, pinned to a git TAG (recommended):
# module "networking" {
#   source = "git::https://github.com/<your-user>/terraform-aws-lab-networking.git?ref=v1.0.0"
#   ...
# }
# After changing `source` or `version`, run: terraform init -upgrade
# ---------------------------------------------------------------------------
