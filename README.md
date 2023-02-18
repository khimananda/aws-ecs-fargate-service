# Following example can be used to launch fargate service
- By default this will create capacity provider with 100% fargate_spot

```
module "ecs-service" {
  source  = "khimananda/fargate-service/aws"aws-ecs-fargate-service.zip"
  version = "0.0.1"
  name          = "fargate-example"
  environment   = terraform.workspace
  cluster_name  = aws_ecs_cluster.example.cluster_name
  desired_count = 1
  domain        = var.domain

  container = {
    APP_PORT  = "80",
    APP_NAME  = each.key
    image     = "docker mage url"
    log_group = "log-group-name
  }
  # ALB
  alb_suffix_arn    = "alb arn suffix"
  alb_rule_field    = "host-header"
  health_check_path = "/"
  sg                = [] # required for fargate sg inbound rules
  listener_arn      = "alb_listener arn"
  matcher           = "200" #for 

  # VPC
  vpc_id     = "vpc id"
  subnet_ids = module.vpc.private_subnets

}
```