# EC2
output "ec2_bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the backend EC2 instance"
}
output "ec2_backend_public_ip" {
  value       = [for instance in aws_instance.backend : instance.private_ip]
  description = "Public IP of the backend EC2 instance"
}



# S3 & CloudFront
output "s3_bucket_name" {
  value       = aws_s3_bucket.media_bucket.id
  description = "S3 bucket name"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "CloudFront distribution domain name"
}

# RDS
output "rds_endpoint" {
  value       = aws_db_instance.postgres.address
  description = "RDS endpoint"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_secret.arn
  description = "Secrets Manager ARN for DB credentials"
}

# Redis
output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
  description = "Redis endpoint"
}


output "alb_dns_name" {
  value       = aws_alb.backend_alb.dns_name
  description = "DNS name of the ALB"
}
