terraform {
  required_version = ">= 1.2.0"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [var.db_subnet_1_id, var.db_subnet_2_id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.default.id
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t2.micro"
  multi_az               = true
  db_name                = "mydb"
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.database_sg_id]
}