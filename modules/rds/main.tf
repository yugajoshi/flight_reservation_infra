resource "aws_db_instance" "rds-db" {
    identifier = var.db_identifier
  allocated_storage           = var.allocated_storage
  engine                      = var.db_engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  username                    = var.username
  password                    = var.db_password
  port = "3306"
  storage_type = var.storage_type
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot = true
  
  
  tags = {
    Name =  "${var.project}-rds"
    env = "dev"
  }
}
resource "aws_db_subnet_group" "default" {
    name = "${var.project}-subnet-group"
    subnet_ids = data.aws_subnets.default.ids
    tags = {
      Name = "${var.project}-rds-subnet"
      env = "dev"
    }
  
}

resource "aws_security_group" "rds-security_group" {
    name = "terraform-db-sg"
    description = "Allow RDS Port"
    vpc_id = data.aws_vpc.default.id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow 3306 Port"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow Outbound traffic"
    }
}

data "aws_vpc" "default" {
  default = true
}

# Fetch the default Subnet IDs
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Use the first default Subnet (for simplicity)
data "aws_subnet" "default" {
  id = data.aws_subnets.default.ids[0]
}
