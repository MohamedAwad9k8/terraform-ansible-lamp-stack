# Creating VPC
resource "aws_vpc" "lamp_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "lamp_vpc"
    Project = "simple_lamp_stack"
  }
}

# Creating Subnets
resource "aws_subnet" "lamp_public_subnet" {
  vpc_id     = aws_vpc.lamp_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "lamp_public_subnet"
    Project = "simple_lamp_stack"
  }
}

resource "aws_subnet" "lamp_private_subnet" {
  vpc_id     = aws_vpc.lamp_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "lamp_private_subnet"
    Project = "simple_lamp_stack"
  }
}

# Creating an Internet Gateway for the VPC

resource "aws_internet_gateway" "lamp_igw" {
  vpc_id     = aws_vpc.lamp_vpc.id
  tags = {
    Name = "lamp_internet_gateway"
    Project = "simple_lamp_stack"
  }
}

# Creating Route Table for the Public Subnet

resource "aws_route_table" "lamp_public_rt" {
  vpc_id = aws_vpc.lamp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lamp_igw.id
  }

  tags = {
    Name    = "lamp_public_routetable"
    Project = "simple_lamp_stack"
  }
}

# Associate Public Subnet with Public Route Table

resource "aws_route_table_association" "public_subnet_rt_associate" {
  subnet_id = aws_subnet.lamp_public_subnet.id
  route_table_id = aws_route_table.lamp_public_rt.id
}

# Creating Security Groups

resource "aws_security_group" "webserver_sg" {
  vpc_id = aws_vpc.lamp_vpc.id
  name = "webserver_sg"
  description = "SG to Allow HTTP,HTTPS,SSH inbound traffic and all outbound traffic"
  tags = {
    Name = "webserver_sg"
    Project = "simple_lamp_stack"
  }
}


resource "aws_security_group" "dbserver_sg" {
  vpc_id = aws_vpc.lamp_vpc.id
  name = "dbserver_sg"
  description = "SG to Allow MySQL,SSH inbound traffic and all outbound traffic"
  tags = {
    Name = "dbserver_sg"
    Project = "simple_lamp_stack"
  }
}

# Creating Security Group Rules

resource "aws_security_group_rule" "allow_ingress_webserver_sg" {
  type = "ingress"
  security_group_id = aws_security_group.webserver_sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = var.webserver_sg_ingress_ports[count.index]
  to_port = var.webserver_sg_ingress_ports[count.index]
  protocol = "tcp"
  count = length(var.webserver_sg_ingress_ports)
}

resource "aws_security_group_rule" "allow_ingress_dbserver_sg" {
  type = "ingress"
  security_group_id = aws_security_group.dbserver_sg.id
  source_security_group_id = aws_security_group.webserver_sg.id
  from_port = var.dbserver_sg_ingress_ports[count.index]
  to_port = var.dbserver_sg_ingress_ports[count.index]
  protocol = "tcp"
  count = length(var.dbserver_sg_ingress_ports)
}

resource "aws_security_group_rule" "allow_egress_webserver_sg" {
  type = "egress"
  security_group_id = aws_security_group.webserver_sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
  protocol = -1
}

resource "aws_security_group_rule" "allow_egress_dbserver_sg" {
  type = "egress"
  security_group_id = aws_security_group.dbserver_sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
  protocol = -1
}

# Creating Elastic IP for the webserver

resource "aws_eip" "webserver_eip" {
  domain = "vpc"
  tags = {
    Name = "webserver_elastic_ip"
    Project = "simple_lamp_stack"
  }
}

# Creating Elastic IP for the Nat Gateway

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = {
    Name = "nat_gateway_eip"
    Project = "simple_lamp_stack"
  }
}

# Creating a Nat Gateway for the public subnet

resource "aws_nat_gateway" "lamp_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.lamp_public_subnet.id

  tags = {
    Name = "lamp_nat_gateway"
    Project = "simple_lamp_stack"
  }
}

# Creating a Route Table for the private subnet

resource "aws_route_table" "lamp_private_rt" {
  vpc_id = aws_vpc.lamp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lamp_nat_gateway.id
  }

  tags = {
    Name = "lamp_private_routetable"
    Project = "simple_lamp_stack"
  }
}

# Associating the Private Subnet with it's Routing Table

resource "aws_route_table_association" "private_subnet_rt_associate" {
  subnet_id      = aws_subnet.lamp_private_subnet.id
  route_table_id = aws_route_table.lamp_private_rt.id
}

# Creating the Instances

resource "aws_instance" "webserver" {
  ami = "ami-0e82046e2f06c0a68"
  instance_type = "t2.micro"
  key_name = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.lamp_public_subnet.id
  security_groups = [aws_security_group.webserver_sg.id]
  tags = {
    Name = "webserver"
    Project = "simple_lamp_stack"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_instance" "dbserver" {
  ami = "ami-0e82046e2f06c0a68"
  instance_type = "t2.micro"
  key_name = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.lamp_private_subnet.id
  security_groups = [aws_security_group.dbserver_sg.id]
  tags = {
    Name = "dbserver"
    Project = "simple_lamp_stack"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}

# Attaching the EIP to the WebServer

resource "aws_eip_association" "webserver_eip_association" {
  instance_id = aws_instance.webserver.id
  allocation_id = aws_eip.webserver_eip.id
}
