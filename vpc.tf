# # # #
# VPC #
# # # #
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(var.tags, {
    Name = "main-vpc"
  })
}


# # # # # #
# Subnets #
# # # # # #
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/17"
  availability_zone = var.availability_zone

  tags = merge(var.tags, {
    Name = "main-vpc"
  })
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/17"
  availability_zone = var.availability_zone

  tags = merge(var.tags, {
    Name = "main-vpc"
  })
}


# # # # 
# IGW #
# # # #
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "main-igw"
  })
}



# # # # # #
# NAT-GW  #
# # # # # #
resource "aws_eip" "main" {
  tags = merge(var.tags, {
    Name = "main-eip-nat-gw"
  })
}

resource "aws_nat_gateway" "main" {
  depends_on = [aws_subnet.public]

  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id
  tags = merge(var.tags, {
    Name = "main-nat-gw"
  })
}


# # # # # # # # #
# route-tables  #
# # # # # # # # #
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(var.tags, {
    Name = "route-table-private-subnet"
  })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, {
    Name = "route-table-public-subnet"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
