data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
  owners = ["amazon"]
}

module "ec2_with_s3" {
  source = "./modules/ec2_with_s3"

  vpc_id                 = aws_vpc.main.id
  ec2_instance_name      = "my-instance"
  ec2_encryption_key_arn = aws_kms_key.ebs.arn
  ec2_instance_ami       = data.aws_ami.amazon_linux_2023.id
  ec2_instance_type      = "t3.micro"
  ec2_root_volume_size   = 20
  ec2_root_volume_type   = "gp3"
  ec2_subnet_id          = aws_subnet.private.id
  ec2_availability_zone  = var.availability_zone
  s3_bucket_name         = "my-s3-bucket"
  s3_encryption_key_arn  = aws_kms_key.s3.arn
  s3_public_access_block = true
  s3_versioning          = true
  tags                   = var.tags
}
