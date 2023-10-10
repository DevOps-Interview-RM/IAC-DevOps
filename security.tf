### Start Poduction SG's

#Prod Public SG
resource "aws_security_group" "vpc-1_public" {
  name        = "Allow inbound"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc-1.id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["99.25.228.5/32"]
  }
  tags = {
    Name = "prod-pub-in"
  }
}

#Private Security groups
resource "aws_security_group" "vpc-1_private" {
  name        = "private"
  description = "Allow private traffic"
  vpc_id      = aws_vpc.vpc-1.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-2]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-2]
  }

  tags = {
    Name = "prod-private"
  }
}

### Start DMZ SG's

#DMZ Public SG
resource "aws_security_group" "vpc-2_public" {
  name        = "Allow inbound dmz"
  description = "Allow inbound traffic to dmz"
  vpc_id      = aws_vpc.vpc-2.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["99.25.228.5/32"]
  }
  tags = {
    Name = "dmz-pub-in"
  }
}


#DMZ Private SG
resource "aws_security_group" "vpc-2_private" {
  name        = "private"
  description = "Allow privatetraffic"
  vpc_id      = aws_vpc.vpc-2.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-1]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-1]
  }

  tags = {
    Name = "dmz-private"
  }
}

