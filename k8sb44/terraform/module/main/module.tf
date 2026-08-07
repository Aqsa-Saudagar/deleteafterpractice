module "vpc" {
  source = "../resource/vpc"

  this_cidr    = "10.0.0.0/16"
  this_subcidr = "10.0.0.0/24"
}

module "ec2" {
  source = "../resource/ec2"

  amiid      = "ami-0bdc7d025135d7b49"
  insttype   = "t3.micro"
  sg         = module.vpc.security_group_id
  kp         = "key"
  apiterm    = false
  ws_subnet  = module.vpc.subnet_id
}