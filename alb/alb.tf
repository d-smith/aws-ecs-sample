resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    description = "security group ecs app load balancer"

    ingress {
            from_port = 80
            to_port = 80
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
        Name = "ECS ALB SG"
    }
}

resource "aws_alb" "test" {
  name            = "ecs-alb-tf"
  internal        = false
  security_groups = ["${aws_security_group.alb_sg.id}"]
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
