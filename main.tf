data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.function_name}-iam-role"
  description        = "Lambda Role"
  assume_role_policy = data.aws_iam_policy_document.role
}

resource "aws_iam_role_policy_attachment" "vpc_execution" {
  count      = var.subnet_ids != [] ? 1 : 0
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = length(var.iam_policies)
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = element(var.iam_policies, count.index)
}

data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content  = "hello"
    filename = "world.txt"
  }
}

resource "aws_lambda_function" "l" {
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.function_handler

  filename = data.archive_file.dummy.output_path

  runtime = var.function_runtime

  environment {
    variables = var.environment_vars
  }

  memory_size = var.function_memory_size
  timeout     = var.function_timeout

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = var.tags
}
