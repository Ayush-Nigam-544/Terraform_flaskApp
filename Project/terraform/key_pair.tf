resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}
