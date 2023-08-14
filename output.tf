output "bag_pre_parser_lambda_arn" {
  value       = aws_lambda_function.bag_pre_parser.arn
  description = "Bag Pre Parser Lambda ARN"
}

output "bag_pre_parser_lambda_role" {
  value       = aws_lambda_function.bag_pre_parser.role
  description = "Bag Pre Parser Lambda Role"
}
