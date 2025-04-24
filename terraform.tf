terraform {
  backend "s3" {
    bucket         = "strapi-naina-bucket"
    key            = "Strapi-Day5-ALB-Fargate/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}
