/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-8aa61c8a"
    ap-southeast-2 = "ami-5ddc9f67"
    eu-west-1      = "ami-2aaef35d"
    us-east-1      = "ami-b540eade"
    us-west-1      = "ami-5721df13"
    us-west-2      = "ami-cb584dfb"
  }
}

variable "aws_region" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "The aws ssh key name."
  default = ""
}


variable "subnet" {}
variable "profile_name" {}