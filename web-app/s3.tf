resource "aws_s3_bucket" "this" {
  bucket = "watch-list.f1kart.com"

  acl = "public-read"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.this.bucket
  acl = "public-read"

  key = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"

  etag = filemd5("${path.module}/index.html")
}

resource "aws_s3_bucket_object" "javascript" {
  bucket = aws_s3_bucket.this.bucket
  acl = "public-read"

  key = "watchList.js"
  source = "${path.module}/watchList.js"
  content_type = "text/html"

  etag = filemd5("${path.module}/watchList.js")
}