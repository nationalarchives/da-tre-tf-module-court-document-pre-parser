# Court Document Pre Parser Lambda
resource "aws_lambda_function" "court_document_pre_parser" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}da-tre-fn-court-document-pre-parser:${var.court_document_pre_parse_image_versions.tre_court_document_pre_parse}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-court_document-pre-parser"
  role          = aws_iam_role.court_document_pre_parser_role.arn
  timeout       = 30
  memory_size   = 1024

  tracing_config {
    mode = "Active"
  }

  tags = {
    "ApplicationType" = "Scala"
  }
}

resource "aws_lambda_permission" "court_document_pre_parser_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.court_document_pre_parser.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.da_eventbus_topic_arn
}

resource "aws_lambda_function_event_invoke_config" "pre_parser_success_failure_destinations" {
  function_name = aws_lambda_function.court_document_pre_parser.function_name
  destination_config {
    on_success {
      destination = var.success_destination_lambda_arn
    }
    on_failure {
      destination = var.failure_destination_lambda_arn
    }
  }
}
