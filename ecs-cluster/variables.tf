variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "cluster_name" {
    description = "ECS cluster name"
    default = "dev-center"
}