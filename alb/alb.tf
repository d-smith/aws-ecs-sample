

resource "aws_alb" "test" {
  name            = "ecs-alb-tf"
  internal        = false
  security_groups = ["${var.alb_sg}"]
  subnets         = ["${var.public_subnet_1}","${var.public_subnet_2}"]
   
  tags {
    Name = "ECS ALB"
  }
}


resource "aws_alb_target_group" "test_tg" {
  name     = "tf-example-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
      path = "/health"
      port = 15000
  }
}


resource "aws_alb_listener" "test_listener" {
   load_balancer_arn = "${aws_alb.test.arn}"
   port = "80"
   protocol = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.test_tg.arn}"
     type = "forward"
   }
}
