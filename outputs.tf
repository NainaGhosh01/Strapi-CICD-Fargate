output "strapi_alb_url" {
  value = "http://${aws_lb.strapi_alb.dns_name}"
}
