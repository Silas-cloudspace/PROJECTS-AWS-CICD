# s3.tf

resource "aws_s3_bucket" "website_bucket" {
  bucket = "your bucket name"
}

resource "aws_s3_bucket_ownership_controls" "website_bucket_ownership_controls" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
   bucket = aws_s3_bucket.website_bucket.id

   block_public_acls = false
   block_public_policy = false
   ignore_public_acls = false
   restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
    depends_on = [
        aws_s3_bucket_ownership_controls.website_bucket_ownership_controls,
        aws_s3_bucket_public_access_block.website_bucket_public_access_block
    ]
    bucket = aws_s3_bucket.website_bucket.id
    acl    = "public-read"
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PublicReadGetObject"
        Effect   = "Allow"
        Principal = "*"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}
