output "sqs_id" {
  value = aws_sqs_queue.source.id
}

output "sqs_arn" {
  value = aws_sqs_queue.source.arn
}
