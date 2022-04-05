# # ---------------------------------------------------
# #    Pushing logs from CloudWatch to Datadog
# # ---------------------------------------------------
# resource aws_cloudwatch_log_subscription_filter datadog_log_subscription_filter {
#     name            = "${var.name_prefix}-${var.wm_instance}-${var.service_name}-Datadog-Filter"
#     log_group_name  = "${var.name_prefix}/ecs/${var.cluster_name}/${var.service_name}/"
#     destination_arn = var.datadog_forwarder_arn
#     filter_pattern  = ""
# }
