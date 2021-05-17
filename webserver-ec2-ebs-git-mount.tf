provider "aws" {
	region = "ap-south-1"
	profile = "default"
}
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

resource "aws_instance" "ec2_instance" {
	ami = "ami-010aff33ed5991201"
	instance_type = "t2.micro"
	security_groups = [
		aws_security_group.allow_port_80.name
		]
	key_name = "myfirstkeypair"
	tags = {
		Name = "Webserver_ec2_Terraform"
		}
}

resource "null_resource" "software_installation" {
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/root/AWS_keys/myfirstkeypair.pem")
    host     = aws_instance.ec2_instance.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php git -y",
      "sudo systemctl enable httpd --now",
    ]
  }

}
resource "aws_ebs_volume" "ebs_creation" {
	availability_zone = aws_instance.ec2_instance.availability_zone
	size = 1
	tags = {
		Name = "EBS_Terraform"
		}
}
resource "aws_volume_attachment" "ec2_ebs_attachment" {
	device_name = "/dev/xvdc"
	volume_id = aws_ebs_volume.ebs_creation.id
	instance_id = aws_instance.ec2_instance.id
	force_detach=True
}
output "ec2_ebs_attachment_output" {
	value = aws_volume_attachment.ec2_ebs_attachment
}
resource "null_resource" "volume_mount" {
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/root/AWS_keys/myfirstkeypair.pem")
    host     = aws_instance.ec2_instance.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdc",
      "sudo mount /dev/xvdc /var/www/html",
    ]
  }

}
resource "null_resource" "code_deploy" {
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/root/AWS_keys/myfirstkeypair.pem")
    host     = aws_instance.ec2_instance.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo wget  https://raw.githubusercontent.com/shubhambhardwaj007/Terraform-Practice-Repository/master/test_webpage.html -P /var/www/html/",
      "sudo systemctl restart httpd"
    ]
  }

}
output "ec2_ipaddress" {
        value =  aws_instance.ec2_instance.public_ip
}

