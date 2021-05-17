resource "null_resource" "volume_mount" {
depends_on=[
aws_volume_attachment.ec2_ebs_attachment
]
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/root/AWS_keys/myfirstkeypair.pem")
    host     = aws_instance.ec2_instance.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdc",
      "sudo sleep 10",
      "sudo mount /dev/xvdc /var/www/html",
    ]
  }

}

