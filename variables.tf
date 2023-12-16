
##################################
#--- ECS Task Definition Vars ---#
##################################

variable "name" {
  type = string
}

variable "requires_compatibilities" {
  type        = list(string)
  default     = ["FARGATE"]
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE"
}

variable "domain" {
  type        = string
  description = "domain name"
}

variable "db_access_secret_arn" {
  type        = string
  default     = null
  description = "Secrete manager arn for db access"
}

variable "environment" {
  type        = string
  description = "Environment e.g. dev/demo/stage"
}

variable "cpu" {
  type    = number
  default = 1024
}

variable "memory" {
  type    = number
  default = 2048
}

#########################################
#-------Container Definition ------------
#########################################

variable "container" {
  type        = map(any)
  description = "this map should contain all jinja template variable for container definition"
}


##########################
#--- ECS Service Vars ---#
##########################

variable "cluster_name" {
  type        = string
  description = "Reference to the ECS cluster id."
}

variable "desired_count" {
  type        = number
  description = "Determinate how many task will running."
}

variable "exposed_container" {
  type        = string
  default     = "app"
  description = "Container that is reachable from outside."
}

variable "launch_type" {
  type        = string
  default     = "FARGATE"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

# variable "app_port" {
#   type        = number
#   description = "Determinate on which port the application on the container will speak."
# }

variable "health_check_grace_period" {
  type        = string
  default     = 300
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647."
}



#####################################
#--- ALB Target Group & Listener ---#
#####################################

variable "protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol to use for routing traffic to the targets. Should be one of TCP, TLS, UDP, TCP_UDP, HTTP or HTTPS."
}

variable "matcher" {
  type        = string
  default     = "200"
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values e.g. 200, 202 or a range of values like 200-299."
}

variable "listener_arn" {
  type        = string
  description = "The ARN of the listener to which to attach the rule."
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request. Applies to Application Load Balancers only HTTP/HTTPS, not Network Load Balancers TCP."
}

variable "type" {
  type        = string
  default     = "forward"
  description = "The type of routing action. Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc."
}

variable "alb_rule_field" {
  type        = string
  default     = "host-header"
  description = "The name of the field. Must be one of path-pattern for path based routing or host-header for host based routing."
}


variable "sg" {
  type        = list(string)
  description = "Security Group Ingress only from the ALB."
}


variable "alb_arn" {
  type        = string
  description = "ALB suffix arn for target group alarm."
}

#######################
#--- VPC Vars ---#
#######################

variable "vpc_id" {
  type        = string
  description = "Will referenced via a data source."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Will referenced via a data source."
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(string)
  description = "Add tags to the different resources."
}

variable "capacity_provider" {
  type = map(string)
  default = {
    "spot_weight" = 100,
    "weight"      = 0
    "base"        = 0

  }
  description = "capacity provider"
}

variable "autoscaling_target_value" {
  type = map(string)
  default = {
    cpu          = 50,
    memory       = 70,
    requestCount = 100
  }
}

variable "autoscaling" {
  type    = bool
  default = false
}

variable "cloudwatch_alarm" {
  type = map(string)
  default = {
    "5xx" = 1
  }
}

variable "sns_topic_arn" {
  type = string
}

variable "enable_public_endpoint" {
  type        = bool
  default     = true
  description = "This will Create ALB listener Rule and Target group for ECS"
}

variable "template_suffix" {
  type = string
  default="template"
}