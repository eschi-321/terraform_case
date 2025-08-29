locals {
  default_tags_ec2 = merge(var.tags,
    {
      environment = "homecase",
      company     = "pixxio"
    }
  )

  default_tags_s3 = merge(var.tags,
    {
      environment = "homecase",
      company     = "pixxio",
      cdnbucket   = false
    }
  )
}
