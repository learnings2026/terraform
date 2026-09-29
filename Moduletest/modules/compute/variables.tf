variable "name" {
  type        = string
  description = "Name prefix."
}

variable "create_instance" {
  type        = bool
  default     = false
  description = "Set true to actually launch the EC2 instance."
}

variable "subnet_id" {
  type        = string
  description = "Subnet to launch into (comes from the networking module output)."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups to attach (from the networking module output)."
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Only nano/micro sizes are allowed - a cost guardrail."

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t4g.micro", "t2.nano", "t3.nano"], var.instance_type)
    error_message = "Cost guardrail: only t2.micro, t3.micro, t4g.micro, t2.nano, t3.nano are allowed in this lab."
  }
}

variable "associate_public_ip" {
  type        = bool
  default     = false
  description = "Public IPv4 is billable (~$0.005/hr) outside the Free Tier allowance."
}

variable "tags" {
  type    = map(string)
  default = {}
}
