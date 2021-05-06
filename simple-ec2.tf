provider "aws" {
region="ap-south-1"
}
resource "aws_instance" "terraform_instance" {
ami ="ami-010aff33ed5991201"
instance_type="t2.micro"
tags={
Name="terraform-instance-change"
}
}
