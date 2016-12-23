resource "aws_ecs_task_definition" "service" {
  family = "hc_task"
  container_definitions = "${file("hc.json")}"
  
  volume {
    name = "root"
    host_path = "/"
  }

  volume {
    name = "var_run"
    host_path = "/var/run"
  }
}