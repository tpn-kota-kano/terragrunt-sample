data "aws_caller_identity" "main" {}

resource "aws_iam_role" "example" {
  name = "${var.common_vars.feature_name_prefix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.main.account_id
        }
      }
    }
  })
}

resource "aws_iam_role_policy" "source" {
  name = "${var.common_vars.feature_name_prefix}-source-role"
  role = aws_iam_role.example.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
        ],
        Resource = [
          var.app_source.sqs_arn,
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "target" {
  name = "${var.common_vars.feature_name_prefix}-target-role"
  role = aws_iam_role.example.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
        ],
        Resource = [
          aws_sqs_queue.target.arn,
        ]
      },
    ]
  })
}

resource "aws_pipes_pipe" "example" {
  name     = "${var.common_vars.feature_name_prefix}-pipe"
  role_arn = aws_iam_role.example.arn
  source   = var.app_source.sqs_arn
  target   = aws_sqs_queue.target.arn

  depends_on = [aws_iam_role_policy.source, aws_iam_role_policy.target]
}

resource "aws_sqs_queue" "target" {
  name = "${var.common_vars.feature_name_prefix}-target-queue"
}
