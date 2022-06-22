output web_alb_arn {
  value = aws_lb.web_alb.arn
}

output web_alb {
  value = aws_lb.web_alb
}

output lb_domain_name {
  value = aws_route53_record.alb.name
}