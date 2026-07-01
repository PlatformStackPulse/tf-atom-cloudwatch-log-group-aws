# Unit tests for tf-atom-cloudwatch-log-group-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform init -backend=false && terraform test
# Run verbose:      terraform test -verbose
# Run a single one: terraform test -run "creates_when_enabled"

mock_provider "aws" {}

# tf-label labels shared by every run. The module has no required inputs of
# its own (log_group_name, retention_in_days, kms_key_id all have defaults),
# so the labels are the only values needed to produce a deterministic id.
variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"
}

# ---------------------------------------------------------------------------
# When enabled (default), the log group is created and outputs are populated.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should be enabled by default"
  }

  assert {
    condition     = output.name != null
    error_message = "Log group name output should be non-null when created"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this[0].retention_in_days == 30
    error_message = "retention_in_days should default to 30"
  }
}

# ---------------------------------------------------------------------------
# A custom log group name is honoured over the derived /aws/{id} default.
# ---------------------------------------------------------------------------
run "honours_custom_log_group_name" {
  command = plan

  variables {
    log_group_name    = "/eg/test/thing"
    retention_in_days = 90
  }

  assert {
    condition     = aws_cloudwatch_log_group.this[0].name == "/eg/test/thing"
    error_message = "log_group_name input should override the derived name"
  }

  assert {
    condition     = aws_cloudwatch_log_group.this[0].retention_in_days == 90
    error_message = "retention_in_days input should be applied to the log group"
  }
}

# ---------------------------------------------------------------------------
# When disabled, no resources are created and the arn output is null.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "Module should report disabled"
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output should be null when the module is disabled"
  }

  assert {
    condition     = length(aws_cloudwatch_log_group.this) == 0
    error_message = "No log group should be created when disabled"
  }
}
