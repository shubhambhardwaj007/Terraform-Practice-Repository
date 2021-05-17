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

