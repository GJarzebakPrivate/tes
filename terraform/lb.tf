
resource "aws_lb_target_group" "tessian" {
  name        = "tessian"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.tessian]
}




resource "aws_alb" "tessian" {
  name               = "tessian-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = module.vpc.public_subnets

  security_groups = [
    aws_security_group.egress_all.id,
    aws_security_group.ingress_api.id
  ]

}

resource "aws_alb_listener" "tessian_http" {
  load_balancer_arn = aws_alb.tessian.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tessian.arn
  }

}
