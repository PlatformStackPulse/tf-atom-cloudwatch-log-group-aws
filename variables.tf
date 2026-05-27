variable "log_group_name" {
  description = "Name of the log group (defaults to /aws/{module-id})"
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Log retention in days (0 = never expire)"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS key ARN for log encryption"
  type        = string
  default     = null
}
