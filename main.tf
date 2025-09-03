resource "aws_vpc" "TENACITY-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TENACITY-VPC"
  }
}
resource "aws_subnet" "prod-pub-sub-1" {
  vpc_id     = aws_vpc.TENACITY-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub-1"
  }
  }
resource "aws_subnet" "prod-pub-sub-2" {
  vpc_id     = aws_vpc.TENACITY-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub-2"
  }
}
resource "aws_subnet" "prod-pri-sub-1" {
  vpc_id     = aws_vpc.TENACITY-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-pri-sub-1"
  }
  }
  resource "aws_subnet" "prod-pri-sub-2" {
  vpc_id     = aws_vpc.TENACITY-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-pri-sub-2"
  }
}
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.TENACITY-VPC.id

  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.TENACITY-VPC.id

tags = {
    Name = "prod-pub-route-table"
  }
}

resource "aws_route_table" "prod-pri-route-table" {
  vpc_id = aws_vpc.TENACITY-VPC.id

tags = {
    Name = "prod-pri-route-table"
  }
}
resource "aws_route_table_association" "pub-sub1-association" {
  subnet_id      = aws_subnet.prod-pub-sub-1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

resource "aws_route_table_association" "pub-sub2-association" {
  subnet_id      = aws_subnet.prod-pub-sub-2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}
resource "aws_route_table_association" "pri-sub1-association" {
  subnet_id      = aws_subnet.prod-pri-sub-1.id
  route_table_id = aws_route_table.prod-pri-route-table.id
}
resource "aws_route_table_association" "pri-sub2-association" {
  subnet_id      = aws_subnet.prod-pri-sub-2.id
  route_table_id = aws_route_table.prod-pri-route-table.id
}
resource "aws_route" "TENACITY-ROUTE" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.prod-igw.id
 }

  resource "aws_eip" "NAT-EIP" {
  
}

resource "aws_nat_gateway" "prod-Nat-gateway" {
  allocation_id = aws_eip.NAT-EIP.id
  subnet_id     = aws_subnet.prod-pub-sub-1.id

  tags = {
    Name = "prod-Nat-gateway"
  }
}

resource "aws_route" "prod_nat_association" {
  route_table_id         = aws_route_table.prod-pri-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.prod-Nat-gateway.id
}