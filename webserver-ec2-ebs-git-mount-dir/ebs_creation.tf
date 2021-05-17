resource "aws_ebs_volume" "ebs_creation" {
        availability_zone = aws_instance.ec2_instance.availability_zone
        size = 1
        tags = {
                Name = "EBS_Terraform"
                }
}
