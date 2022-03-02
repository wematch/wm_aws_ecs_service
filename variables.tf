variable vpc_id {}
variable subnets {}
variable image_name {}
variable logdna_key {}
variable name_prefix {}
variable domain_name {}
variable aws_lb_arn {}
variable ecr_region {}
variable ecr_account_id {}
variable security_groups {}
variable aws_lb_certificate_arn {}
variable capacity_provider_name {}

variable aws_lb_out_port {
  type    = number
  default = null
}
variable image_version {
  type    = string
  default = "latest"
}
variable wm_instance {
  type = string
  default = "fargate"
}
variable standard_tags {
  type = map(string)
}
variable cluster_name {
  type = string
}
variable service_name {
  type = string
}
variable container_cpu {
  type    = number
  default = 256
}
variable container_memory {
  type    = number
  default = 512
}
variable task_cpu {
  type    = number
  default = 256
}
variable task_memory {
  type    = number
  default = 512
}
variable service_port {
  type    = number
}
variable entrypoint {
  type    = list(string)
  default = null
}
variable command {
  type    = list(string)
  default = null
}
variable desired_count {
  type    = number
  default = 1
}
variable max_capacity {
  type    = number
  default = 1
}
variable min_capacity {
  type    = number
  default = 1
}
variable container_cpu_low_threshold {
  type    = number
  default = 60
}
variable container_cpu_high_threshold {
  type    = number
  default = 30
}
variable task_role_arn {
  type    = string
  default = null
}
variable health_check_grace_period_seconds {
  type    = number
  default = null
}
variable additional_containers {
  description = "Additional containers definition"
  default = []
}
# variable s3_log_bucket {
#   type = string
# }
variable public {
  default = false
}

variable mount_points {
  type = list(object({
    containerPath = string
    sourceVolume  = string
    readOnly      = bool
  }))
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`"
  default     = []
}

variable volumes {
  type = list(object({
    name      = string
    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
    }))
  }))
  description = "Task volume definitions as list of configuration objects"
  default     = []
}

variable environment {
  type = list(object({
    name  = any
    value = any
  }))
  description = "List of Env Vars"
  default     = []
}

variable secrets {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of Secrets"
  default     = []
}
