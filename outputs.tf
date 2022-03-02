output service_port {
    value = var.service_port
}

output cloudwatch_log_group_name {
    value = aws_cloudwatch_log_group.ecs_group.name
}
