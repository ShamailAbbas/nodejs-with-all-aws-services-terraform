# -----------------------
# RDS
# -----------------------

# Subnet Group (requires 2 subnets)
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.project_name}-rds-subnets"
  subnet_ids = [aws_subnet.public.id, aws_subnet.public_2.id]
}

# RDS Instance
resource "aws_db_instance" "postgres" {
  identifier           = "${var.project_name}-db"
  engine               = "postgres"
  instance_class       = var.rds_instance_type
  allocated_storage    = 20
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_subnets.name
  skip_final_snapshot  = true
  publicly_accessible  = true
}

# Secrets Manager for DB credentials
resource "aws_secretsmanager_secret" "db_secret" {
  name = var.db_secret_name
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    dbname   = var.db_name
  })
}
