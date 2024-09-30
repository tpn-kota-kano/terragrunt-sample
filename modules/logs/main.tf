resource "aws_iam_role" "sqs_cloudwatch_role" {
  name = "${var.common_vars.feature_name_prefix}-sqs-cloudwatch-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "sqs_cloudwatch_policy" {
  name = "${var.common_vars.feature_name_prefix}-sqs-cloudwatch-policy"
  role = aws_iam_role.sqs_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "source" {
  name = "/aws/sqs/${var.common_vars.feature_name_prefix}-sqs-source-log-group"
}

resource "aws_sqs_queue_policy" "sqs_cloudwatch_policy_source" {
  queue_url = var.app_source.sqs_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = var.app_source.sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_log_group.source.arn
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "target" {
  name = "/aws/sqs/${var.common_vars.feature_name_prefix}-sqs-target-log-group"
}

resource "aws_sqs_queue_policy" "sqs_cloudwatch_policy_target" {
  queue_url = var.app_target.sqs_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = var.app_target.sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_log_group.target.arn
          }
        }
      }
    ]
  })
}
