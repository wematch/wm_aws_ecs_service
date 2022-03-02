# ---------------------------------------------------
#    LogDNA pushing logs from CloudWatch
# ---------------------------------------------------
module lambda {
    # Source: https://github.com/logdna/logdna-cloudwatch
    # Manual: https://docs.logdna.com/docs/cloudwatch

    source                  = "terraform-aws-modules/lambda/aws"
    version                 = "2.34.1"
    function_name           = "${var.name_prefix}-${var.wm_instance}-${var.service_name}"
    description             = "Push logs CloudWatch -> LogDNA - ${var.service_name} at ${var.wm_instance}"
    handler                 = "index.handler"
    runtime                 = "nodejs14.x"
    timeout                 = 10
    memory_size             = 256
    maximum_retry_attempts  = 0
    create_package          = false
    local_existing_package  = "lambda.zip"
    tags                    = var.standard_tags

    environment_variables = {
        LOGDNA_KEY        = var.logdna_key
        LOGDNA_TAGS       = "service_name=${var.service_name}, image_version=${var.image_version}, cluster=${var.wm_instance}"
    }
}

resource aws_lambda_permission allow_cloudwatch {
    action        = "lambda:InvokeFunction"
    function_name = module.lambda.lambda_function_name
    principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
    source_arn    = aws_cloudwatch_log_group.ecs_group.arn
}

resource aws_cloudwatch_log_subscription_filter lambda_logfilter {
    name            = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-Filter"
    log_group_name  = "${var.name_prefix}/ecs/${var.cluster_name}/${var.service_name}/"
    filter_pattern  = ""
    destination_arn = module.lambda.lambda_function_arn
    distribution    = "ByLogStream"
    depends_on      = [aws_lambda_permission.allow_cloudwatch]
}
