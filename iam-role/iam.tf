resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${file("ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name     = "ecs_instance_role_policy"
  policy   = "${file("ecs-instance-role-policy.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}

output "iam_profile" {
    value = "${aws_iam_instance_profile.ecs.name}"
}