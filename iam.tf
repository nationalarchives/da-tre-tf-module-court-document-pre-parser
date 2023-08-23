# Lambda Roles & Policies
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "court_document_pre_parser_role" {
  name               = "${var.env}-${var.prefix}-court_document-pre-parser-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "court_document_pre_parser_lambda_logs" {
  role       = aws_iam_role.court_document_pre_parser_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "invoke_success_failure_destination_lambdas" {
  role       = aws_iam_role.court_document_pre_parser_role.name
  policy_arn = aws_iam_policy.pre_parser_lambda_invoke_policy.arn
}

data "aws_iam_policy_document" "pre_parser_lambda_invoke_policy_data" {
  statement {
    sid     = "InvokeLambdaPolicy"
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [
      var.success_destination_lambda_arn,
      var.failure_destination_lambda_arn
    ]
  }
}

resource "aws_iam_policy" "pre_parser_lambda_invoke_policy" {
  name        = "${var.env}-${var.prefix}-pre-parser-lambda-invoke"
  description = "The policy for pre parser lambda to invoke success/failure destination lambdas"
  policy      = data.aws_iam_policy_document.pre_parser_lambda_invoke_policy_data.json
}
