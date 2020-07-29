/******************************VPC********************************/


resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name = "VPC-terraform"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.default.id
}

/****************************Security Group***********************/

resource "aws_security_group" "nat_security_gp" {
    name = "Public-EC2-SG"
    vpc_id = aws_vpc.default.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    

    tags= {
        Name = "NAT-SG"
    }
}

/************************EC2**************************/

resource "aws_instance" "public_instance" {
    ami = var.AWS_AMI
    availability_zone = "ap-south-1a"
    instance_type = var.AWS_INSTANCE_TYPE
    key_name      = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.nat_security_gp.id]
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    source_dest_check = false
    user_data = data.template_file.user_data.rendered

    tags= {
        Name = "Public-EC2"
    }
}

data "template_file" "user_data" {
  template = file("templates/user_data.tpl")
}


/**********************Public Subnet*****************/

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.public_subnet_cidr
    availability_zone = "ap-south-1a"

    tags= {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "public_RT" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }

    tags= {
        Name = "Public RT"
    }
}

resource "aws_route_table_association" "public_RT_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_RT.id
}

/***********************Private Subnet*********************/

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.default.id
    cidr_block = var.private_subnet_cidr
    availability_zone = "ap-south-1a"

    tags= {
        Name = "Private Subnet"
    }
}

/*******************************Elastic IP******************/

resource "aws_eip" "eip" {
    vpc = true
}


/******************************NAT-GATEWAY******************/

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet.id
  depends_on = [aws_internet_gateway.default]

  tags = {
    Name="NAT-GW"
  }
}

resource "aws_route_table" "private_RT" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
#        instance_id = "aws_instance.public_instance.id"
	nat_gateway_id = aws_nat_gateway.nat_gateway.id

    }

    tags= {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "private_RT_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_RT.id
}




