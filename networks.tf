### Create VPC's ###
resource "aws_vpc" "vpc-1" {
  provider             = aws.region-master
  cidr_block           = var.vpc-1
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-main"
  }
}
resource "aws_vpc" "vpc-2" {
  provider             = aws.region-master
  cidr_block           = var.vpc-2
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-secondary"
  }
}
#Create internet Gateways
resource "aws_internet_gateway" "vpc-1-igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-1.id
}

resource "aws_internet_gateway" "vpc-2-igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-2.id
}

#Get Az's
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

#create subnets
resource "aws_subnet" "vpc-1-pub-1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = var.vpc-1-pub[0]
  tags = {
   Name = "vpc-1-Pub-1"
  }
}

resource "aws_subnet" "vpc-1-priv" {
  count             = "${length(var.vpc-1-priv)}"
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "${element(var.vpc-1-priv, count.index)}"
  tags = {
    Name = "vpc-1-Priv"
  }
  
}

resource "aws_subnet" "vpc-2-pub-1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-2.id
  cidr_block        = var.vpc-2-pub[0]
  tags = {
    Name = "vpc-2-Pub"
  }
}


resource "aws_subnet" "vpc-2-priv-1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-2.id
  cidr_block        = var.vpc-2-priv[0]
  tags = {
    Name = "vpc-2-priv"
  }
}


resource "aws_default_route_table" "vpc-1-default" {
  default_route_table_id = aws_vpc.vpc-1.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-1-igw.id
  }
  tags = {
    Name = "vpc-1-public"
  }
}

resource "aws_default_route_table" "vpc-2-default" {
  default_route_table_id = aws_vpc.vpc-2.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-2-igw.id
  }
  tags = {
    Name = "vpc-2-public"
  }
}

resource "aws_route_table_association" "private" {
  count             = "${length(var.vpc-1-priv)}"
  subnet_id = "${element(aws_subnet.vpc-1-priv.*.id, count.index)}"
  route_table_id = aws_route_table.vpc-1-priv.id
}


resource "aws_route_table" "vpc-1-priv" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block =  var.vpc-2-priv[0]

    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }
  tags = {
    Name = "vpc-1-priv"
  }
}

resource "aws_route_table" "vpc-2-priv" {
  vpc_id = aws_vpc.vpc-2.id
  route {
    cidr_block         = var.vpc-1-priv[0]
    transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  }
  tags = {
    Name = "vpc-2-priv"
  }
}
### Shared Resources ###

# Create TGW
resource "aws_ec2_transit_gateway" "tgw-1" {
  description = "Primary tgw"
  tags = {
    Name = "tgw"
  }
}

# Attatch TGW to subnets
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-1-tgw" {
  subnet_ids         = toset([element(aws_subnet.vpc-1-priv.*.id, 0)])
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  vpc_id             = aws_vpc.vpc-1.id

  tags = {
    Name = "main priv"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-2-tgw" {
  subnet_ids         = [aws_subnet.vpc-2-priv-1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw-1.id
  vpc_id             = aws_vpc.vpc-2.id

  tags = {
    Name = "secondary priv"
  }
}


