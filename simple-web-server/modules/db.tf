
resource "aws_db_instance" "db" {
  allocated_storage                     = 20
  auto_minor_version_upgrade            = true
  backup_retention_period               = 7
  copy_tags_to_snapshot                 = true
  db_subnet_group_name                  = aws_db_subnet_group.sg.name
  deletion_protection                   = true
  engine                                = "mysql"
  engine_version                        = "5.7.22"
  iam_database_authentication_enabled   = false
  identifier                            = "simple-web-server"
  instance_class                        = "db.t2.micro"
  iops                                  = 0
  license_model                         = "general-public-license"
  max_allocated_storage                 = 1000
  option_group_name                     = "default:mysql-5-7"
  parameter_group_name                  = aws_db_parameter_group.mysql-jp.name
  multi_az                              = false
  performance_insights_retention_period = 0
  port                                  = 3306
  publicly_accessible                   = false
  storage_encrypted                     = false
  storage_type                          = "gp2"
  username                              = "user"
  password                              = "password"
  vpc_security_group_ids                = [aws_security_group.db.id]
  skip_final_snapshot                   = true
}

resource "aws_db_subnet_group" "sg" {
  description = "Created by Terraform"
  name        = "simple-web-server"
  subnet_ids  = [aws_subnet.public-a.id, aws_subnet.public-b.id]
}

resource "aws_db_parameter_group" "mysql-jp" {
  description = "Customized for Japanese by Terraform"
  family      = "mysql5.7"
  name        = "mysql-jp"

  parameter {
    apply_method = "immediate"
    name         = "character_set_connection"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_database"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_results"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "time_zone"
    value        = "asia/tokyo"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_server"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_client"
    value        = "utf8mb4"
  }
}
