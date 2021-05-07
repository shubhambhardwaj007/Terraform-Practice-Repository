provider "aws" {
profile="terraform_user"
}

resource "aws_instance" "ec2_instance" {
ami = "ami-010aff33ed5991201"
instance_type = "t2.micro"
tags = {
Name= "ec2-ebs-attach"
}
}

output "ec2_output_id" {
value = aws_instance.ec2_instance.id
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone =  aws_instance.ec2_instance.availability_zone
  size              = 5
  tags = {
    Name= "ebs-attach"
  }
}
output "ebs_volume_id" {
value = aws_ebs_volume.ebs_volume.id
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.ec2_instance.id
}

