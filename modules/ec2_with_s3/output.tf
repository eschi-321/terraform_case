output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "ec2_public_ip" {
  value = aws_instance.this.public_ip
}
