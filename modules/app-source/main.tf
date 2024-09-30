resource "aws_sqs_queue" "source" {
  name = "${var.common_vars.feature_name_prefix}-source-queue"
}
