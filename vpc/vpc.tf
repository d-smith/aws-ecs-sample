resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet1_cidr}","${var.private_subnet2_cidr}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet1_cidr}","${var.private_subnet2_cidr}"]
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
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-6d29b85d" # this is a special ami preconfigured to do NAT
    availability_zone = "us-west-2a"
    instance_type = "t1.micro"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}

/*
 ============= Availability Zone A ===============
*/

/*
  Public Subnet
*/
resource "aws_subnet" "us-west-2a-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true

    tags {
        Name = "Public Subnet Zone A"
    }
}

resource "aws_route_table" "us-west-2-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "public subnet route table"
    }
}

resource "aws_route_table_association" "us-west-2a-public" {
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    route_table_id = "${aws_route_table.us-west-2-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-west-2a-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet1_cidr}"
    availability_zone = "us-west-2a"

    tags {
        Name = "Private Subnet Zone A"
    }
}

resource "aws_route_table" "us-west-2-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "private subnet route table"
    }
}

resource "aws_route_table_association" "us-west-2a-private" {
    subnet_id = "${aws_subnet.us-west-2a-private.id}"
    route_table_id = "${aws_route_table.us-west-2-private.id}"
}

/*
 ============= Availability Zone B ===============
*/
resource "aws_subnet" "us-west-2b-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "us-west-2b"
    map_public_ip_on_launch = true

    tags {
        Name = "Public Subnet Zone B"
    }
}

resource "aws_route_table_association" "us-west-2b-public" {
    subnet_id = "${aws_subnet.us-west-2b-public.id}"
    route_table_id = "${aws_route_table.us-west-2-public.id}"
}

resource "aws_subnet" "us-west-2b-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet2_cidr}"
    availability_zone = "us-west-2b"

    tags {
        Name = "Private Subnet Zone B"
    }
}

resource "aws_route_table_association" "us-west-2b-private" {
    subnet_id = "${aws_subnet.us-west-2b-private.id}"
    route_table_id = "${aws_route_table.us-west-2-private.id}"
}

// Module Outputs

output "vpc_id" {
    value = "${aws_vpc.default.id}"
}

output "private_subnet_a" {
    value = "${aws_subnet.us-west-2a-private.id}"
}

output "private_subnet_b" {
    value = "${aws_subnet.us-west-2b-private.id}"
}