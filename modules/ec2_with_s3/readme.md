# Module ec2_with_s3

<p>Provides a module to create an S3 bucket (in us-east-1) and a ec2-instance (in eu-central-1). <br>
All resources in this module are tagged with _environment = "homecase"_ and _company = "pixxio"_. <br>
The S3-bucket is not meant as a cdn-bucket and therefore is tagged additionally with _cdnbucket = false_. <br>
It's possible to add own tags in addition via the _tags_-variable.<p>

<p>Make sure to provide a subnet with proper routetable assigned. <br>
The RT must allow access to nat-gw/igw in order to allow ec2 to access s3 in the other region! <p>

## Example of usage

```
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
  ec2_availability_zone  = "eu-central-1a"
  s3_bucket_name         = "my-s3-bucket"
  s3_encryption_key_arn  = aws_kms_key.s3.arn
  s3_public_access_block = true
  s3_versioning          = true
  tags                   = var.tags
}
```

## Argument Reference

| variable               | Description                                                    |
| ---------------------- | -------------------------------------------------------------- |
| vpc_id                 | VPC-ID of the vpc to use for the ec2.                          |
| ec2_instance_name      | Name of the ec2-instance.                                      |
| ec2_encryption_key_arn | ARN of the kms-key used to encrypt the ec2-volumes.            |
| ec2_instance_ami       | AMI used for the ec2-instance.                                 |
| ec2_instance_type      | Instance-type used for the ec2-instance.                       |
| ec2_root_volume_size   | Size of the root ec2-volume.                                   |
| ec2_root_volume_type   | Type of the root ec2-volume.                                   |
| ec2_subnet_id          | ID of the subnet used for the ec2-instance.                    |
| ec2_availability_zone  | Availability zone used for the ec2-instance.                   |
| s3_bucket_name         | Name of the s3-bucket.                                         |
| s3_encryption_key_arn  | ARN of the kms-key used to encrypt the bucket.                 |
| s3_public_access_block | Set to true if public access should be blocked for the bucket. |
| s3_versioning          | Set to true if bucket-versioning should be enabled.            |
| tags                   | Tags that are applied to all resources created by this module. |
