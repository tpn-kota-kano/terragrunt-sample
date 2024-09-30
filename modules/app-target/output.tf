output "sqs_id" {
  value = aws_sqs_queue.target.id
}

output "sqs_arn" {
  value = aws_sqs_queue.target.arn
}
