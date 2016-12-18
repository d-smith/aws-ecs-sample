resource "aws_ecs_task_definition" "service" {
  family = "cadvisor_service"
  container_definitions = "${file("cadvisor.json")}"
  
  volume {
    name = "root"
    host_path = "/"
  }

  volume {
    name = "var_run"
    host_path = "/var/run"
  }

  volume {
    name = "sys"
    host_path = "/sys"
  }

  volume {
    name = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }
}