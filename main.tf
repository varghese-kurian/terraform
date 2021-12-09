# Creating VPC 
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.Vpc_name
  }
}

# Creating basion subnet
resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet[count.index]
}

# Creating private subnet
resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet[count.index]
}


# Creating internet gate way
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name =  var.Igw_name
  }
}

# Creating elastic ip for NAT gateway
resource "aws_eip" "elasticip" {
  vpc = true
  tags = {
    Name = var.Elastic_name
  }
}

#Creating NAT gateway
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.elasticip.allocation_id
  subnet_id     = aws_subnet.public_subnet.0.id
  tags = {
    Name = var.Nat_name
  }
  }

# Creating route table public and allocating desired routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
   route {
    cidr_block = var.open
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = var.public_subnet_name
  }
}

# Creating route table private and allocating desired routes
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
   route {
    cidr_block = var.open
    gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = var.private_subnet_name
  }
}

#Assosiating Public subnet in public route tabel
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

#Assosiating Private subnet in private route tabel
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

# Fetching my ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# public security group
resource "aws_security_group" "public_sg" {
  name = "sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

#private security group
resource "aws_security_group" "private_sg" {
  name = "pri_sg"
  vpc_id = aws_vpc.vpc.id
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(aws_instance.public_host.private_ip)}/32"]
  }
}

# Public instance
  resource "aws_instance" "public_host" {
  ami                    = "ami-00782a7608c7fc226"
  subnet_id              = element(aws_subnet.public_subnet.*.id, 1)
  instance_type          = "t2.micro"
  key_name               = "mysql"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public_sg.id]
}


# private instance
resource "aws_instance" "private_host" {
  ami                    = "ami-00782a7608c7fc226"
  subnet_id              = element(aws_subnet.private_subnet.*.id, 1)
  instance_type          = "t2.micro"
  key_name               = "mysql"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.private_sg.id]
}