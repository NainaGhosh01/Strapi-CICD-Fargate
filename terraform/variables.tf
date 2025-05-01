variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "strapi_image" {
  description = "ECR image for Strapi"
  default     = "724772070195.dkr.ecr.us-east-1.amazonaws.com/naina-strapi-repo:latest"
}
