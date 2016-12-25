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