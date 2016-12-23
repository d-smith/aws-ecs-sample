resource "aws_security_group" "instance_sg" {
    name = "instance_sg"
    description = "security group ecs instances"

    ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }

    vpc_id = "${var.vpc_id}"

    tags {
        Name = "ECS Instance SG"
    }
}


resource "aws_instance" "ecs_a" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "ECS cluster member"
    }
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_a}"
    user_data = "${file("ecs_setup.txt")}"
    iam_instance_profile = "${var.profile_name}"
    vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]
}

resource "aws_instance" "ecs_b" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "ECS cluster member"
    }
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_b}"
    user_data = "${file("ecs_setup.txt")}"
    iam_instance_profile = "${var.profile_name}"
    vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]
}