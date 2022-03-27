resource "aws_security_group" "ecs_security_group" {
  count = var.enable == true ? 1 : 0

  name   = "${var.name}-ecs-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.service.container_port
    to_port     = var.service.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ecs-security-group"
  }
}