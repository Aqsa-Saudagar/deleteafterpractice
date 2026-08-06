provider "aws" {
  region  = "us-east-1"
  profile = "configs"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "web_sg" {

  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_lb" {

  name = "simple-alb"

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.web_sg.id
  ]

  subnets = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "tg" {

  name = "simple-tg"

  port = 80

  protocol = "HTTP"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.app_lb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_launch_template" "example" {

  image_id = "ami-0bdc7d025135d7b49"

  instance_type = "t3.micro"

  vpc_security_group_ids = [
      aws_security_group.web_sg.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello World" > /var/www/html/index.html
EOF
)
}

resource "aws_autoscaling_group" "asg" {

  desired_capacity = 2

  min_size = 1

  max_size = 3

  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [
      aws_lb_target_group.tg.arn
  ]

  launch_template {

      id = aws_launch_template.example.id

      version = "$Latest"
  }
}

output "alb_dns" {

  value = aws_lb.app_lb.dns_name
}