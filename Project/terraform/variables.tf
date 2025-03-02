# Terraform variables
variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_name" {
  default = "studentdb"
}

variable "db_user" {
  default = "dbadmin"
}

variable "db_password" {
  default = "password1234"
}