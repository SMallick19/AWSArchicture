resource "aws_vpc" "cloudArc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    environment = var.environment
    managedby   = "Terraform"
  }
}

resource "aws_internet_gateway" "cloudIGW" {
  vpc_id = aws_vpc.cloudArc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_subnet" "publicSubnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.cloudArc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.cloudArc.id

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "publicInternet" {
  route_table_id         = aws_route_table.publicRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.cloudIGW.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.publicSubnet)

  subnet_id      = aws_subnet.publicSubnet[count.index].id
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_eip" "NatEip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-aws-nat-eip"
  }
}

resource "aws_nat_gateway" "cloudNatGate" {
  allocation_id = aws_eip.NatEip.id
  subnet_id     = aws_subnet.publicSubnet[0].id

  tags = {
    Name = "${var.environment}-nat"
  }

  depends_on = [
    aws_internet_gateway.cloudIGW
  ]
}

resource "aws_subnet" "privateSubnet" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.cloudArc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.cloudArc.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route" "privateInternet" {
  route_table_id         = aws_route_table.privateRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cloudNatGate.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.privateSubnet)

  subnet_id      = aws_subnet.privateSubnet[count.index].id
  route_table_id = aws_route_table.privateRouteTable.id
}
