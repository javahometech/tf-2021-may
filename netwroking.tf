# Create VPC

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name       = "main-vpc-${terraform.workspace}"
    Location   = "Banglore"
    CostCenter = "JHHJ123MN"
  }
}

# Create public subnets
# Create subnets equal to number of azs
resource "aws_subnet" "public" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "public-${count.index + 1}"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myapp-gw"
  }
}

# Create Route table for public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Subnet Association to public route table

resource "aws_route_table_association" "public" {
  count          = length(local.pub_sub_ids)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Create private subnets
# Create subnets equal to number of azs
resource "aws_subnet" "private" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.pub_sub_ids))
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "private-${count.index + 1}"
  }
}

# Create Route table for private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_nat_gateway.gw.id
  # }
  tags = {
    Name = "private-rt"
  }
}

# Subnet Association to public route table

resource "aws_route_table_association" "private" {
  count          = length(local.pri_sub_ids)
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.private.id
}

# # Create eip
# resource "aws_eip" "nat" {
#   vpc      = true
# }

# # Create NAT Gateway
# resource "aws_nat_gateway" "gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = local.pub_sub_ids[0]
# }