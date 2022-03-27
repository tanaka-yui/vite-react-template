resource "aws_alb" "alb" {
  name                       = "${var.name}-alb"
  internal                   = false
  security_groups            = [aws_security_group.alb_security_group.id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  depends_on = [
    aws_security_group.alb_security_group,
  ]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "forbidden"
      status_code  = "403"
    }
  }

  depends_on = [
    aws_alb.alb,
  ]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.name}-alb-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = var.health_check_path
    port                = var.port
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 4
    matcher             = var.health_check_matcher
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  dynamic "condition" {
    for_each = var.allow_http_headers
    content {
      http_header {
        http_header_name = condition.value.name
        values           = condition.value.values
      }
    }
  }

  depends_on = [
    aws_alb_listener.alb_listener,
    aws_alb_target_group.alb_target_group
  ]
}

resource "aws_security_group" "alb_security_group" {
  name   = "${var.name}-alb-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allow_http_hosts
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-security-group"
  }
}
