variable "name" {
  description = "Name prefix for all resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block, e.g. 10.0.0.0/16."
  }
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks, one public subnet per entry."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "Provide at least one public subnet CIDR."
  }
}

variable "tags" {
  description = "Extra tags merged onto every resource."
  type        = map(string)
  default     = {}
}
