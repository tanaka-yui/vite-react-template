locals {
  INSTANCE_NAME = "${local.name}-maintenance"
  // Amazon Linux 2 AMI (HVM), SSD Volume Type 64 ビット x86 (TokyoRegionのAMI)
  // Amazon Linux 2はSystemManagerのAgentが標準インストールされているためPatch Managerが使える
  AMAZON_LINUX_2_AMI = "ami-06631ebafb3ae5d34"
}

resource "aws_instance" "ec2_maintenance" {
  ami                         = local.AMAZON_LINUX_2_AMI
  instance_type               = "t3a.micro"
  key_name                    = data.terraform_remote_state.remote_state_immutable.outputs.maintenance_key_pair_name
  subnet_id                   = aws_subnet.subnet_public_a.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.security_group_maintenance.id
  ]

  tags = {
    Name          = local.INSTANCE_NAME
    "Patch Group" = local.INSTANCE_NAME
  }

  depends_on = [
    aws_subnet.subnet_public_a,
    aws_security_group.security_group_maintenance
  ]
}

resource "aws_eip" "ec2_maintenance_eip" {
  instance = aws_instance.ec2_maintenance.id
  vpc      = true

  tags = {
    Name = "${local.INSTANCE_NAME}-eip"
  }

  depends_on = [aws_instance.ec2_maintenance]
}

resource "aws_security_group" "security_group_maintenance" {
  name   = local.INSTANCE_NAME
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.maintenance_server_allow_hosts
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr_block]
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.INSTANCE_NAME
  }
}

resource "aws_iam_role" "ec2_maintenance" {
  name               = local.INSTANCE_NAME
  assume_role_policy = file("${path.module}/template/ec2/role/ec2-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "ecs_agent_ssm" {
  role       = aws_iam_role.ec2_maintenance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  depends_on = [aws_iam_role.ec2_maintenance]
}

resource "aws_iam_instance_profile" "ec2_maintenance" {
  name = local.INSTANCE_NAME
  role = aws_iam_role.ec2_maintenance.name

  depends_on = [aws_iam_role.ec2_maintenance]
}