# Load Balancer for Flask App
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.ec2_sg.id]
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id] # Ensure different AZs
  enable_deletion_protection = false

  tags = {
    Name = "my-alb"
  }
}

# resource "aws_lb" "flask_alb" {
#   name               = "flask-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
# }

# resource "aws_lb" "my_alb" {
#   name               = "my-alb"
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.ec2_sg.id]
#   subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

# }
