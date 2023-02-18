output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "task_execution_role_id" {
  value = aws_iam_role.ecs_task_execution_role.id
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "task_role_id" {
  value = aws_iam_role.ecs_task_role.id
}

output "service_name" {
  value = aws_ecs_service.this.name
}
