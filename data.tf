data "aws_ecs_cluster" "fargate" {
  cluster_name = var.cluster_name
}