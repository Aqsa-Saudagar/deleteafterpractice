provider "aws" {
  region = "us-east-1"
  profile = "configs"
} 

#Partitionkey = LockID
terraform {
    backend "s3" {
        bucket = "cbz-terraformb44"
        key = "terraform.tfstate"
        dynamodb_table = "b44"
        region = "us-east-1"
        profile = "configs"
        shared_credentials_files = ["/root/.aws/credentials"]
    }
}



resource "aws_instance"  "webserver" {
    ami = var.amiid
    instance_type = var.insttype
    vpc_security_group_ids =  [ var.sg]
    key_name = var.kp
}