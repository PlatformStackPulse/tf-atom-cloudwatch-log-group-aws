resource "aws_cloudwatch_log_group" "this" {
  count = module.this.enabled ? 1 : 0

  name              = var.log_group_name != null ? var.log_group_name : "/aws/${module.this.id}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id

  tags = module.this.tags
}
