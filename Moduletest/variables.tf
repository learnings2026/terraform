variable "region" {
  description = "AWS region for the lab."
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Prefix used for naming and tagging."
  type        = string
  default     = "tf-modules-lab"
}

variable "environment" {
  description = "Environment name (dev/test/prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per entry)."
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

# ---- COST SAFETY SWITCHES -------------------------------------------------
variable "create_instance" {
  description = "Phase 2 switch. false = no EC2 is created (zero cost)."
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "EC2 size. The compute module only accepts micro/nano sizes."
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip" {
  description = "WARNING: AWS charges ~$0.005/hr for any public IPv4 address (Free Tier covers 750 hrs/month for eligible accounts). Keep false unless you need it."
  type        = bool
  default     = false
}
