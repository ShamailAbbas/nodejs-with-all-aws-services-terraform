# -----------------------
# RDS Subnet Group (requires 2 subnets)
# -----------------------
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.project_name}-rds-subnets"
  subnet_ids = [aws_subnet.db-private_subnet_1.id, aws_subnet.db-private_subnet_2.id]

  tags = {
    Name = "${var.project_name}-rds-subnets"
  }
}

# -----------------------
# RDS Security Group
# -----------------------
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Postgres from App SG"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # 🔐 Best practice: only allow from your app's SG
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.backend-private_subnet_1.cidr_block, aws_subnet.backend-private_subnet_2.cidr_block]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# -----------------------
# RDS Instance
# -----------------------
resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-db"
  engine                 = "postgres"
  instance_class         = var.rds_instance_type
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "${var.project_name}-rds"
  }
}

# -----------------------
# Secrets Manager for DB credentials
# -----------------------
resource "aws_secretsmanager_secret" "db_secret" {
  name = var.db_secret_name

  tags = {
    Name = "${var.project_name}-db-secret"
  }
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
