provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "inno-my-static-website"

  tags = { "Name" = "Static Web Site S3", "Environment" = "Prod" }
}

resource "aws_s3_bucket_website_configuration" "static_website_configuration" {
  bucket = aws_s3_bucket.static_website.id

  index_document { suffix = "index.html" }
  error_document { key = "error.html" }

  depends_on = [aws_s3_bucket.static_website]
}

module "addObjects" {
  source = "./modules/s3_object"

  bucket       = aws_s3_bucket.static_website.id
  key          = ["index.html", "error.html", "schrek.png"]
  sourceTo     = ["./src/s3-static-website/index.html", "./src/s3-static-website/error.html", "./src/s3-static-website/schrek.png"]
  content_type = ["text/html", "text/html", "text/html"]

  depends_on = [aws_s3_bucket.static_website]
}

resource "aws_s3_bucket_ownership_controls" "objectWriter" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "ObjectWriter"
  }

  depends_on = [aws_s3_bucket.static_website]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls   = false
  block_public_policy = false

  depends_on = [aws_s3_bucket_ownership_controls.objectWriter]
}

resource "aws_s3_bucket_acl" "public_read" {
  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.static_website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://inno-my-static-website.s3.eu-north-1.amazonaws.com/*"]
    expose_headers  = [""]
    max_age_seconds = 3000
  }

  depends_on = [aws_s3_bucket_acl.public_read]
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.static_website.id
  policy = var.bucket_policy

  depends_on = [aws_s3_bucket_cors_configuration.this]
}
