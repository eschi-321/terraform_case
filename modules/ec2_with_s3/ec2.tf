resource "aws_network_interface" "this" {
  provider  = aws.eu_central_1
  subnet_id = var.ec2_subnet_id
  tags      = local.default_tags_ec2
}

resource "aws_instance" "this" {
  provider               = aws.eu_central_1
  ami                    = var.ec2_instance_ami
  instance_type          = var.ec2_instance_type
  availability_zone      = data.aws_availability_zones.available.names[0]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  tags = merge(local.default_tags_ec2, {
    Name = var.ec2_instance_name
  })

  root_block_device {
    volume_type           = var.ec2_root_volume_type
    volume_size           = var.ec2_root_volume_size
    kms_key_id            = var.ec2_encryption_key_arn
    encrypted             = true
    delete_on_termination = true
    tags                  = local.default_tags_ec2
  }
}


resource "aws_security_group" "this" {
  name        = "${var.ec2_instance_name}-sg"
  description = "Security group for ec2 instance"
  vpc_id      = var.vpc_id
  tags = merge(local.default_tags_ec2, {
    Name = "${var.ec2_instance_name}-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "this_443" {
  security_group_id = aws_security_group.this.id
  description       = "Allow outbound-communication via 443"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  tags              = local.default_tags_ec2
}



resource "aws_iam_instance_profile" "this" {
  name = "${var.ec2_instance_name}-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name        = "${var.ec2_instance_name}-instance-role"
  description = "role for ec2-instance: ${var.ec2_instance_name}"
  tags = merge(local.default_tags_ec2, {
    Name = "${var.ec2_instance_name}-instance-role"
  })
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "this" {
  name = "${var.ec2_instance_name}-instance-policy"
  tags = merge(local.default_tags_ec2, {
    Name = "${var.ec2_instance_name}-instance-policy"
  })

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "S3ListBucket",
          "Effect" : "Allow",
          "Action" : [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
          "Resource" : "${aws_s3_bucket.this.arn}"
        },
        {
          "Sid" : "S3ObjectLevelReadWrite",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload",
            "s3:ListBucketMultipartUploads",
            "s3:ListMultipartUploadParts"
          ],
          "Resource" : "${aws_s3_bucket.this.arn}/*"
        },
        {
          "Sid" : "AllowUseOfKmsKeyForS3",
          "Effect" : "Allow",
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" : "${var.s3_encryption_key_arn}",
          "Condition" : {
            "StringEquals" : {
              "kms:ViaService" : "s3.us-east-1.amazonaws.com"
            },
            "StringLike" : {
              "kms:EncryptionContext:aws:s3:arn" : "${aws_s3_bucket.this.arn}/*"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
