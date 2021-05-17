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

