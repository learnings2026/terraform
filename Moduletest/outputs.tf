# Root outputs re-export child module outputs: module.<name>.<output>
output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "instance_id" {
  description = "null when create_instance = false"
  value       = module.compute.instance_id
}

output "bucket_names" {
  value = {
    app  = module.app_bucket.bucket_name
    logs = module.logs_bucket.bucket_name
  }
}
