#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  #provider = aws
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmiOregon" {
  #provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create EC2 in prod
resource "aws_instance" "prod-node" {
  #provider                    = aws
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.vpc-1_public.id]
  subnet_id                   = aws_subnet.vpc-1-pub-1.id

  tags = {
    Name = "prod-Fwl-1"
  }
}

resource "aws_instance" "dmz-node" {
  #provider                    = aws
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.vpc-2_public.id]
  subnet_id                   = aws_subnet.vpc-2-pub-1.id

  tags = {
    Name = "dmz-fwl-1"
  }
}

#Create additional ENI
resource "aws_network_interface" "prod-private-1" {
  subnet_id       = element(aws_subnet.vpc-1-priv.*.id, 0)
  security_groups = [aws_security_group.vpc-1_private.id]

  attachment {
    instance     = aws_instance.prod-node.id
    device_index = 2
  }
  tags = {
    Name = "vpc-1-private-eni-1"
  }
}

resource "aws_network_interface" "vpc2-private-1" {
  subnet_id       = aws_subnet.vpc-2-priv-1.id
  security_groups = [aws_security_group.vpc-2_private.id]

  attachment {
    instance     = aws_instance.dmz-node.id
    device_index = 2
  }
  tags = {
    Name = "dmz-priv-nic1"
  }
}
