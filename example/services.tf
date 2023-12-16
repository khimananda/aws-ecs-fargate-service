resource "aws_ecs_cluster" "example" {
  name = "example-cluster"
}
module "ecs-service" {
  source        = "/home/khimananda/khim-tf-libraries/aws-ecs-fargate-service"#"s3::/portpro-tf-modules/1.0.23/aws-ecs-fargate-service.zip"
  name          = "fargate-example"
  environment   = terraform.workspace
  cluster_name  = aws_ecs_cluster.example.cluster_name
  desired_count = 1
  domain        = each.value

  container = {
    APP_PORT  = "80",
    APP_NAME  = each.key
    image     = aws_ecr_repository.this[each.key].repository_url
    log_group = aws_cloudwatch_log_group.this[each.key].name
  }
  # ALB
  alb_suffix_arn    = data.terraform_remote_state.portpro.outputs.ecs_alb_arn_suffix
  alb_rule_field    = "host-header"
  health_check_path = "/"
  sg                = [data.terraform_remote_state.portpro.outputs.web-server-sg] # required for fargate sg inbound rules
  listener_arn      = data.terraform_remote_state.portpro.outputs.ecs_listener_arn
  matcher           = "200,302,404"

  # VPC
  vpc_id     = "vpc id"
  subnet_ids = module.vpc.private_subnets

  tags = merge(
    #  local.common_tags,
  )
  cpu    = 1024
  memory = 2048

  capacity_provider = {
    spot_weight = 100
    weight      = 0
    base        = terraform.workspace == "live" ? 2 : 0 #fargate base
  }

  autoscaling = true

}