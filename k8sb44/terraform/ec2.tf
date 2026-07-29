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
    user_data = <<-EOF
                 #!/bin/bash
                 sudo yum install nginx -y
                 sudo systemctl start nginx



                EOF
}

resource "aws_security_group" "webserver_sg" {
    name = "tf-sg"
    ingress {
      from_port = 80
      to_port = 80
      protocol = "TCP"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }


    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks  = ["0.0.0.0/0"]

    }

}