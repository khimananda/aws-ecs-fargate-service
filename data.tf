data "aws_ecs_cluster" "fargate" {
  cluster_name = var.cluster_name
}

data "aws_lb" "this" {
  arn = var.alb_arn
}