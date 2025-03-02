# Terraform outputs
output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.student_db.endpoint
}
resource "local_file" "private_key" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "C:/Users/user/.ssh/id_rsa.pem"
  file_permission = "600"
}
output "ec2_public_ip" {
  value = aws_instance.flask_app.public_ip
}
resource "local_file" "terraform_outputs" {
  filename = "C:/Users/user/Desktop/Project/scripts/terraform_outputs.sh"
  content  = <<EOT
export ALB_DNS_NAME="${aws_lb.my_alb.dns_name}"
export EC2_PUBLIC_IP="${aws_instance.flask_app.public_ip}"
export RDS_ENDPOINT="${aws_db_instance.student_db.endpoint}"
EOT
}
