module "mysql_sg" {
  source = "../../terraform-aws-sg"
  environment = var.environment
  project_name = var.project_name
   sg_name = "mysql"
   vpc_id = local.vpc_id
   common_tags = var.common_tags
   sg_tags = var.mysql_sg_tags
}

module "backend_sg" {
  source = "../../terraform-aws-sg"
  environment = var.environment
  project_name = var.project_name
   sg_name = "backend"
   vpc_id = local.vpc_id
   common_tags = var.common_tags
}

module "frontend_sg" {
  source = "../../terraform-aws-sg"
  environment = var.environment
  project_name = var.project_name
   sg_name = "frontend"
   vpc_id = local.vpc_id
   common_tags = var.common_tags
}

#MYSQL Allowing connection on 3306 port from the instances attached to Backend SG 
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  to_port           = 3306
  from_port = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.vpc_id
  security_group_id = module.mysql_sg.id
}