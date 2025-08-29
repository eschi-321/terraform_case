resource "aws_kms_key" "s3" {
  provider            = aws.us_east_1
  description         = "KMS CMK key for the S3 buckets"
  enable_key_rotation = true
  tags                = var.tags
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Enable IAM User Permissions",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          },
          "Action" : "kms:*",
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "s3.us-east-1.amazonaws.com"
          },
          "Action" : [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ],
          "Resource" : "*",
          "Condition" : {
            "ArnEquals" : {
              "kms:EncryptionContext:aws:s3:arn" : "arn:aws:s3:::*"
            }
          }
        }
      ]
    }
  )
}


resource "aws_kms_key" "ebs" {
  provider            = aws.eu_central_1
  description         = "KMS key for EBS"
  enable_key_rotation = true
  tags                = var.tags
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "account permissions",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
          },
          "Action" : [
            "kms:*"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.eu-central-1.amazonaws.com"
          },
          "Action" : [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*",
            "kms:CreateGrant"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
