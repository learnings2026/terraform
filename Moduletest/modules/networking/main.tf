# COST: VPC, subnets, internet gateway, route tables, security groups = FREE.
# NOT created on purpose: NAT Gateway (~$32+/month) and Elastic IPs.

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names

  common_tags = merge({ Module = "networking" }, var.tags)

  # Convert list -> map so for_each has stable keys ("0", "1", ...)
  public_subnets = { for idx, cidr in var.public_subnet_cidrs : tostring(idx) => cidr }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = local.azs[tonumber(each.key) % length(local.azs)]

  # Deliberately false: public IPv4 addresses are billable.
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, { Name = "${var.name}-public-${each.key}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Locked-down default: NO inbound rules, all outbound allowed.
resource "aws_security_group" "default" {
  name        = "${var.name}-default-sg"
  description = "No inbound; all outbound"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.name}-default-sg" })
}
