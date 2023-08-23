output "court_document_pre_parser_lambda_arn" {
  value       = aws_lambda_function.court_document_pre_parser.arn
  description = "Court Document Pre Parser Lambda ARN"
}

output "court_document_pre_parser_lambda_role" {
  value       = aws_lambda_function.court_document_pre_parser.role
  description = "Court Document Pre Parser Lambda Role"
}
