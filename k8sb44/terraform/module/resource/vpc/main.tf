resource "aws_vpc" "ws_vpc" {
  cidr_block = var.this_cidr
}

resource "aws_subnet" "ws_subnet" {
  vpc_id     = aws_vpc.ws_vpc.id
  cidr_block = var.this_subcidr
}

resource "aws_security_group" "ws_sg" {
  name   = "ws-security-group"
  vpc_id = aws_vpc.ws_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}