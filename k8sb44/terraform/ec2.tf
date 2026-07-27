provider "aws" {
  region = "ap-south-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
} 



resource "aws_instance"  "webserver" {
    ami = "ami-09d88f7c4c272b0c5" 
    instance_type = "t3.micro"
    vpc_security_group_ids =  ["sg-0d06a29eacde65701"]
    key_name = "linuxkey"
    tags = {
        purpose = "webserver"
    }
    count = 2 
}