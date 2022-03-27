locals {
  engine         = "aurora-mysql"
  family         = "aurora-mysql5.7"
  engine_version = "5.7.mysql_aurora.2.10.0"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${local.name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_c.id,
  ]

  tags = {
    Name = "${local.name}-db-subnet-group"
  }

  depends_on = [
    aws_subnet.subnet_private_a,
    aws_subnet.subnet_private_c,
  ]
}

resource "aws_security_group" "db_security_group" {
  name   = "${local.name}-db-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.subnet_private_a.cidr_block,
      aws_subnet.subnet_private_c.cidr_block,
      aws_subnet.subnet_public_a.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-db-security-group"
  }

  depends_on = [
    aws_subnet.subnet_private_a,
    aws_subnet.subnet_private_c,
  ]
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${local.name}-parameter-group"
  family = local.family
}

resource "aws_rds_cluster_parameter_group" "db_cluster_parameter_group" {
  name   = "${local.name}-cluster-parameter-group"
  family = local.family

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "binary"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "time_zone"
    value = "UTC"
  }
}