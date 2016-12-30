resource "aws_ecs_service" "hc_sample_svc" {
  name = "hc_sample_svc"
  cluster = "${var.cluster_id}"
  task_definition = "${var.task_def}"
  desired_count = 1
  iam_role = "${var.role_arn}"
#  depends_on = ["var.policy"]

  load_balancer {
      target_group_arn = "${var.target_group_arn}"
      container_name = "hc"
      container_port = "5000"
  }

}