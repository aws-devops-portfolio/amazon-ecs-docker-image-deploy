output "task_role_arn" {
    value = aws_iam_role.task_service_role.arn
}

output "execution_role_arn" {
  value = aws_iam_role.task_execution_role.arn
}