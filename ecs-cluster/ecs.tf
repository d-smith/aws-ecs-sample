resource "aws_ecs_cluster" "dev-center-cluster" {
  name = "${var.cluster_name}"
}