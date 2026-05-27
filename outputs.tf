output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "arn" {
  description = "ARN of the log group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}

output "name" {
  description = "Name of the log group"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}
