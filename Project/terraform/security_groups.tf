# Security Group for ALB (Load Balancer)
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  # Allow inbound HTTP & HTTPS from anywhere (Public Access)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic to EC2
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}

# Security Group for EC2 Instances (Flask App)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  # Allow HTTP traffic only from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow SSH from anywhere (⚠️ NOT RECOMMENDED, restrict to your IP if possible)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow Flask traffic on port 5000 from anywhere (or restrict it)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (Restrict if needed)
  }
  # Allow Flask traffic on port 5000 from anywhere (or restrict it)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (Restrict if needed)
  }

  # Allow all outbound traffic (including to RDS)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}

# Security Group for RDS (PostgreSQL)
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # Allow incoming PostgreSQL traffic only from EC2's subnet (fixes circular dependency)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private1.cidr_block] # Replace security group reference
  }

  # Allow RDS to send outbound traffic anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
