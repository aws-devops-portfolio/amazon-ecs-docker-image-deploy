# Security Group for ALB 
resource "aws_security_group" "alb_sg" {
  name        = "web_alb_sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web_alg_sg"
  }

}

# Public ALB is required for demo project
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "alb_sg_http_rule" {
  description       = "Load Balancer security group HTTP ingress rule"
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = [var.all_traffic]
  from_port         = var.http_port
  protocol          = "tcp"
  to_port           = var.http_port
}

# Public ALB is required for demo project
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "alb_sg_https_rule" {
  description       = "Load Balancer security group HTTPS ingress rule"
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = [var.all_traffic]
  from_port         = var.https_port
  protocol          = "tcp"
  to_port           = var.https_port
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "alb_egress_rule" {
  description       = "Allow ALB outbound HTTPS"
  type              = "egress"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = [var.all_traffic]
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}

# Security Group for ECS tasks
resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs_task_sg"
  description = "ECS Task security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_task_sg"
  }

}

resource "aws_security_group_rule" "ecs_task_sg_http_rule" {
  description              = "Allow HTTP inbound traffic from ALB security group to ECS tasks"
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_task_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  from_port                = 8080 #var.http_port
  protocol                 = "tcp"
  to_port                  = 8080 #var.http_port
}

resource "aws_security_group_rule" "ecs_task_sg_https_rule" {
  description              = "Allow HTTPS inbound traffic from ALB security group to ECS tasks"
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_task_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  from_port                = var.https_port
  protocol                 = "tcp"
  to_port                  = var.https_port
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "ecs_task_sg_egress_rule" {
  description       = "Allow EC2 outbound HTTPS (via NAT)"
  type              = "egress"
  security_group_id = aws_security_group.ecs_task_sg.id
  cidr_blocks       = [var.all_traffic]
  from_port         = var.https_port
  protocol          = "-1"
  to_port           = var.https_port
}

resource "aws_security_group" "vpce_sg" {
  name   = "vpce-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "vpce_https" {
  type                     = "ingress"
  security_group_id        = aws_security_group.vpce_sg.id
  source_security_group_id = aws_security_group.ecs_task_sg.id
  from_port                = var.https_port
  to_port                  = var.https_port
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "vpce_egress" {
  type              = "egress"
  security_group_id = aws_security_group.vpce_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}
