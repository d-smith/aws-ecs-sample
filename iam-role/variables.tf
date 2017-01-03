variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "instance_profile_name" {
    description = "ecs instance profile name"
    default = "ecs-instance-profile"
}