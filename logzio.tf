# ---------------------------------------------------
#    Pushing logs from CloudWatch to Logz.io
# ---------------------------------------------------
resource aws_iam_role iam_lambda_cw_to_logzio {
    name = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-logzio-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

resource aws_iam_policy policy_cw_to_logzio {
    name   = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-logzio-policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "logs:PutResourcePolicy",
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "*",
                "Effect": "Allow"
            }
        ]
    })
}

resource aws_iam_policy_attachment attach_cw_to_logzio {
    name       = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-attachment"
    roles      = [aws_iam_role.iam_lambda_cw_to_logzio.name]
    policy_arn = aws_iam_policy.policy_cw_to_logzio.arn
}

resource aws_lambda_function lambda_cloudwatch_to_logzio {
    function_name   = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-logzio-lambda"
    filename        = "${path.module}/logzio.zip"
    role            = aws_iam_role.iam_lambda_cw_to_logzio.arn
    runtime         = "python3.9"
    handler         = "lambda_function.lambda_handler"
    timeout         = 60
    memory_size     = 512

    environment {
        variables = {
            # Required variables:
            TOKEN = "opXOPsSQzptlpHXAsRcGHaBThyTULuqO" # Your Logz.io shipping token
            LISTENER_URL = "https://listener.logz.io:8071" # Your Logz.io listener host (for example, listener.logz.io)
        }
    }
}

resource aws_cloudwatch_log_group log_group_cw_to_logzio {
    name = "/aws/lambda/${aws_lambda_function.lambda_cloudwatch_to_logzio.function_name}"
}

resource aws_lambda_permission allow_cloudwatch {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_cloudwatch_to_logzio.function_name
    principal     = "logs.amazonaws.com"
}

resource aws_cloudwatch_log_subscription_filter cw_to_logzio_subscription {
    name            = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-filter"
    log_group_name  = "${var.name_prefix}/ecs/${var.cluster_name}/${var.service_name}/"
    filter_pattern  = ""
    destination_arn = aws_lambda_function.lambda_cloudwatch_to_logzio.arn
}
