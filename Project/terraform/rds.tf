# Subnet Group for RDS (Use two private subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  # subnet_ids = [aws_subnet.private1.id]
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id] # ✅ Use two private subnets

  tags = {
    Name = "RDS Subnet Group"
  }
}

# # Security Group for RDS
# resource "aws_security_group" "rds_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [aws_security_group.ec2_sg.id] # ✅ Only EC2 can access RDS
#   }
# }

# RDS Instance for PostgreSQL
resource "aws_db_instance" "student_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = var.db_password
  publicly_accessible    = false # ✅ Keep private
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # ✅ Attach RDS security group
}

# # RDS Instance for PostgreSQL
# # resource "aws_db_instance" "student_db" {
# #   allocated_storage   = 20
# #   engine              = "postgres"
# #   instance_class      = "db.t3.micro"
# #   username            = var.db_user
# #   password            = var.db_password
# #   publicly_accessible = false
# #   skip_final_snapshot = true
# # }

# resource "aws_db_subnet_group" "rds_subnet_group" {
#   name       = "rds-subnet-group"
#   subnet_ids = [aws_subnet.private1.id]

#   tags = {
#     Name = "RDS Subnet Group"
#   }
# }

# resource "aws_db_instance" "student_db" {
#   allocated_storage    = 20
#   engine              = "postgres"
#   instance_class      = "db.t3.micro"
#   username           = var.db_user
#   password           = var.db_password
#   publicly_accessible = false
#   skip_final_snapshot = true
#   db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name  # <- Add this line
# }
