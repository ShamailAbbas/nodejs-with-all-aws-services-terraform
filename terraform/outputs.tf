output "ec2_bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the bastion EC2 instance"
}
output "ec2_backend_private_ip" {
  value       = [for instance in aws_instance.backend : instance.private_ip]
  description = "Private IP of the backend EC2 instances"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.media_bucket.id
  description = "S3 bucket name"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "CloudFront distribution domain name"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_secret.arn
  description = "Secrets Manager ARN for DB credentials"
}


output "redis_host_endpoint" {
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
  description = "Redis host endpoint"
}


output "alb_dns_name" {
  value       = aws_alb.backend_alb.dns_name
  description = "DNS name of the ALB"
}
