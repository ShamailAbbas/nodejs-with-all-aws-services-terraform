# S3 Bucket
resource "aws_s3_bucket" "media_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = false

  #   object_ownership = "BucketOwnerPreferred"
}

# CloudFront OAI
resource "aws_cloudfront_origin_access_identity" "cdn_oai" {
  comment = "${var.project_name} CDN OAI"
}

# Bucket Policy for CloudFront
resource "aws_s3_bucket_policy" "media_bucket_policy" {
  bucket = aws_s3_bucket.media_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { AWS = aws_cloudfront_origin_access_identity.cdn_oai.iam_arn },
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.media_bucket.arn}/*"
    }]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.media_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.media_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cdn_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.media_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
