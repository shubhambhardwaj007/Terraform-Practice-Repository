resource "null_resource" "code_deploy" {
depends_on=[
null_resource.volume_mount
]
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

