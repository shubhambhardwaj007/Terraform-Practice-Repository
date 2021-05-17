resource "aws_security_group" "allow_port_80" {
  name        = "allow_port_80_terraform"
  description = "Allow port 80 inbound traffic"
  vpc_id      = "vpc-6a796502"

  ingress {
    description      = "port 80 allow from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "port 22 allow from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_80_22_port"
  }
}

