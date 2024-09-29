module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-mysql"
  ami  = data.aws_ami.chinna.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-backend"
  ami  = data.aws_ami.chinna.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-frontend"
  ami  = data.aws_ami.chinna.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ansible" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-ansible"
  ami  = data.aws_ami.chinna.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_ids
  user_data = file("expense.sh")
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  

  zone_name = var.zone_name

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip
      ]
    },
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    }
  ]
}