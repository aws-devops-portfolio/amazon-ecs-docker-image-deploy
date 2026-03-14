# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    name = "main"
  }
}

data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  # Use only first 2 AZs
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids          = slice(aws_subnet.private-subnet[*].id, 0, 2)
  security_group_ids  = [var.vpce_sg_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids         = slice(aws_subnet.private-subnet[*].id, 0, 2)
  security_group_ids = [var.vpce_sg_id]

  private_dns_enabled = true
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
  count      = length(local.selected_azs)
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 1)

  availability_zone = local.selected_azs[count.index % length(local.selected_azs)]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private-subnet" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 11)

  availability_zone = local.selected_azs[count.index % length(local.selected_azs)]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Elastic IP Address
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT-gw"
  }
}

# Public Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate Public Subnets
resource "aws_route_table_association" "public_assoc" {
  count          = length(local.selected_azs)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}


# Private Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private-rt"
  }

}

# Associate Private Subnets
resource "aws_route_table_association" "private_assoc" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
