terraform {
  required_version = ">=1.10.0"

  backend "s3" {
    bucket  = "k8s-terraform-state-3213213"
    key     = "video-cms/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "terraform-lock"
  }
}

