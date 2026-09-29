variable "name" {
  type        = string
  description = "Bucket name prefix. Account ID and region are appended for global uniqueness."
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = "Lab convenience: lets `terraform destroy` delete a non-empty bucket. Use false in production."
}

variable "tags" {
  type    = map(string)
  default = {}
}
