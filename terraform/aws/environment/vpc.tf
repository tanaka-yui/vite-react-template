resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_eip" "eip_a" {
  vpc = true

  tags = {
    Name = "${local.name}-nat-gateway-eip-a"
  }
}

resource "aws_eip" "eip_c" {
  vpc = true

  tags = {
    Name = "${local.name}-nat-gateway-eip-c"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-igw"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.eip_a.id
  subnet_id     = aws_subnet.subnet_public_a.id

  tags = {
    Name = "${local.name}-nat-gateway-a"
  }

  depends_on = [
    aws_eip.eip_a,
    aws_subnet.subnet_public_a
  ]
}

resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.eip_c.id
  subnet_id     = aws_subnet.subnet_public_c.id

  tags = {
    Name = "${local.name}-nat-gateway-c"
  }

  depends_on = [
    aws_eip.eip_c,
    aws_subnet.subnet_public_c
  ]
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-rtb-public"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "route_table_private_a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-rtb-private-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route" "route_nat_a" {
  route_table_id         = aws_route_table.route_table_private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id

  depends_on = [
    aws_route_table.route_table_private_a,
    aws_nat_gateway.nat_gateway_a,
  ]
}

resource "aws_route_table" "route_table_private_c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-rtb-private-c"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route" "route_nat_c" {
  route_table_id         = aws_route_table.route_table_private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_c.id

  depends_on = [
    aws_route_table.route_table_private_c,
    aws_nat_gateway.nat_gateway_c,
  ]
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  depends_on = [
    aws_route_table.route_table_public,
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_main_route_table_association" "main_route_table_association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.route_table_public.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_public_a" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.subnet_public_a.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_public_c" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.subnet_public_c.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_private_a" {
  route_table_id = aws_route_table.route_table_private_a.id
  subnet_id      = aws_subnet.subnet_private_a.id

  depends_on = [aws_route_table.route_table_private_a]
}

resource "aws_route_table_association" "route_table_association_private_c" {
  route_table_id = aws_route_table.route_table_private_c.id
  subnet_id      = aws_subnet.subnet_private_c.id

  depends_on = [aws_route_table.route_table_private_c]
}

resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_cidr_public_a
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_cidr_public_c
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name}-public-c"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc.subnet_cidr_private_a
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${local.name}-private-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc.subnet_cidr_private_c
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${local.name}-private-c"
  }

  depends_on = [aws_vpc.vpc]
}
