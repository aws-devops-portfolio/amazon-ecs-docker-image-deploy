# load balancer
resource "aws_lb" "web_alb" {
  name               = "product-app-alb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.alb_sg_id]

  drop_invalid_header_fields = true
}

# target group
resource "aws_lb_target_group" "alb_tg" {
  name        = "web-target-group"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/actuator/health"  
  }

}

# listener
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.web_alb.id
  port              = var.port
  protocol          = var.protocol

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.id
    type             = "forward"
  }
}