# # # # # #
# general #
# # # # # #
variable "tags" {
  description = "Tags that are applied to all resources created by this module."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC-ID of the vpc to use."
  type        = string
}

# # # #
# EC2 #
# # # #
variable "ec2_instance_name" {
  description = "Name of the ec2-instance."
  type        = string
}

variable "ec2_instance_ami" {
  description = "AMI used for the ec2-instance."
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance-type used for the ec2-instance."
  type        = string
}

variable "ec2_subnet_id" {
  description = "ID of the subnet used for the ec2-instance."
  type        = string
}

variable "ec2_availability_zone" {
  description = "Availability zone used for the ec2-instance."
  type        = string
}

variable "ec2_encryption_key_arn" {
  description = "ARN of the kms-key used to encrypt the ec2-volumes."
  type        = string
}

variable "ec2_root_volume_size" {
  description = "Size of the root ec2-volume."
  type        = number
}

variable "ec2_root_volume_type" {
  description = "Type of the root ec2-volume."
  type        = string
}


# # # #
# S3  #
# # # #
variable "s3_bucket_name" {
  description = "Name of the bucket."
  type        = string
}

variable "s3_encryption_key_arn" {
  description = "ARN of the kms-key used to encrypt the bucket."
  type        = string
}

variable "s3_versioning" {
  description = "Set to true if bucket-versioning should be enabled."
  type        = bool
}

variable "s3_public_access_block" {
  description = "Set to true if public access should be blocked for the bucket."
  type        = bool
}
