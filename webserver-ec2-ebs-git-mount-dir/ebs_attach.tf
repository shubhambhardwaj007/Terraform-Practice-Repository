resource "aws_volume_attachment" "ec2_ebs_attachment" {
        device_name = "/dev/xvdc"
        volume_id = aws_ebs_volume.ebs_creation.id
        instance_id = aws_instance.ec2_instance.id
	force_detach= true
}

