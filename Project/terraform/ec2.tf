# EC2 Instance for Flask App
resource "aws_instance" "flask_app" {
  ami           = "ami-0f96c63e39f9144bc"
  instance_type = var.instance_type
  # security_groups = [aws_security_group.ec2_sg.name]
  security_groups = [aws_security_group.ec2_sg.id]
  subnet_id       = aws_subnet.public1.id
  key_name        = aws_key_pair.generated_key.key_name

  tags = {
    Name = "FlaskApp"
  }
}

# resource "aws_instance" "web" {
#   ami           = "ami-0f96c63e39f9144bc"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.public_subnet_1.id
#   security_groups = [aws_security_group.ec2_sg.id]
#   key_name      = aws_key_pair.my_key_pair.key_name
#   tags = {
#     Name = "MyEC2Instance"
#   }
# }
