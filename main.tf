provider "aws"{
	region = "us-east-2"
}
module "rds-db" {
	source = "./modules/rds"
	db_identifier = "flight-rds"
	allocated_storage = 20
	db_engine = "mysql"
	engine_version = "8.0"
	instance_class = "db.t3.micro"
	username = "admin"
	db_password = "kfLH56nzCxKfBCEdSSbwM5ogx"
	storage_type = "gp2"
	project = "flight"
}

module "s3-bucket"{
	source = "./modules/s3"
	project = "flight"
	bucket = "flight-250392-12321"
	env = "dev"
}

module "eks-cluster" {
	source = "./modules/eks"
	project = "flight"
	desired_nodes = 2
	min_nodes = 2
	max_nodes = 2
	node_instance_type = "t3.medium"
}
	
