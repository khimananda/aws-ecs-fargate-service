#######################################
#--- ECS Service - Task-Definition ---#
#######################################

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-taskdefinition"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = templatefile("${path.root}/templates/task_defination_template.json", var.container)

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-task"
    }
  )
}

#####################
#--- ECS Service ---#
#####################

resource "aws_ecs_service" "this" {

  name            = "${var.name}-service"
  cluster         = data.aws_ecs_cluster.fargate.arn
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  #launch_type     = var.launch_type

  health_check_grace_period_seconds = var.health_check_grace_period
  enable_execute_command            = true

  load_balancer {
    target_group_arn = aws_lb_target_group.this[0].arn
    container_name   = var.container["APP_NAME"]
    container_port   = var.container["APP_PORT"]
  }

  # only needed on fargate
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.sg
    assign_public_ip = var.public_ip
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.capacity_provider["spot_weight"]
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = var.capacity_provider["base"]
    weight            = var.capacity_provider["weight"]
  }

  deployment_circuit_breaker {
      enable   = true
      rollback = true
  }

  # propagate_tags = "TASK_DEFINITION"
  lifecycle {
    ignore_changes = [
      task_definition, 
      desired_count,
      capacity_provider_strategy
  ]
  }
  depends_on = [aws_ecs_task_definition.this]

}


resource "aws_secretsmanager_secret" "secrets" {
  name                    = var.domain
  tags                    = var.tags
  recovery_window_in_days = 0
}