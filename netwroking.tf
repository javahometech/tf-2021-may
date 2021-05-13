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
  count = length(aws_subnet.public.*.id)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}