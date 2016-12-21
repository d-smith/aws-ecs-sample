/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    us-east-1      = "ami-6df8fe7a"
    us-west-1      = "ami-1eda8d7e"
    us-west-2      = "ami-a2ca61c2"
  }
}

variable "aws_region" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_a" {}
variable "subnet_b" {}
variable "profile_name" {}
variable "vpc_id" {}
variable "key_name" {}