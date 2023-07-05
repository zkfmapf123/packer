variable "region" {
    default = "ap-northeast-2"
}
variable "env" {
    default = "test"
}

locals {

  publics = {
    "ap-northeast-2a" : "10.0.1.0/24",
    "ap-northeast-2b" : "10.0.2.0/24"
  }

  privates = {
    "ap-northeast-2a" : "10.0.101.0/24",
    "ap-northeast-2b" : "10.0.102.0/24"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "publics" {
  for_each = local.publics

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.env}-public-${each.key}"
  }
}

resource "aws_subnet" "privates" {
  for_each = local.privates

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.env}-private-${each.key}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-igw"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.publics

  subnet_id     = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

output "id" {
    value = aws_vpc.vpc.id
}

output "public_subnets" {
    value = {
        for subnet in aws_subnet.publics:
            subnet.availability_zone => subnet.id
    }
}

output "private_subnets" {
    value = {
        for subnet in aws_subnet.privates:
            subnet.availability_zone => subnet.id
    }
}