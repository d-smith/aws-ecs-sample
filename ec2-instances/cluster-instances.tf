resource "aws_instance" "ecs" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "ECS cluster member"
    }
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet}"
    user_data = "${file("ecs_setup.txt")}"
    iam_instance_profile = "${var.profile_name}"
}