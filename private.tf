/*************************PRIVATE SECURITY GROUP*****************/

resource "aws_security_group" "private_SG" {
    name = "private_EC2_SG"
    vpc_id = "aws_vpc.default.id"
    
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


    egress {
        from_port = 80
        to_port = 80
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
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags= {
        Name = "Private-Instance-SG"
    }
}

/*********************************Key-Pair**********************/

resource "aws_key_pair" "my_key" {
        key_name   = "mykey"
        public_key = file(var.PATH_TO_PUBLIC_KEY)
}

/******************************EC2-Private******************************/

resource "aws_instance" "private_EC2" {
	ami	      = var.AWS_AMI
        availability_zone = "ap-south-1a" 
	instance_type = var.AWS_INSTANCE_TYPE
	key_name      = aws_key_pair.my_key.key_name
	security_groups = [aws_security_group.private_SG.id]
	subnet_id = aws_subnet.private_subnet.id
        source_dest_check = false
	
	tags= {
        Name = "Private-Instance"
        }

}


