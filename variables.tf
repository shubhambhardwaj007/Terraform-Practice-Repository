variable "x" {
  type=string
  default="hello"
}

output "print_value"{
  value="${var.x}"
}
