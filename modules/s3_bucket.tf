resource "aws_s3_bucket" "this" {
  bucket = "cyderes-s3-bucket"

  tags = {
    Name = "cyderes-s3-bucket"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
