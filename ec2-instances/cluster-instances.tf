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
}