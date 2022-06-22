data "aws_acm_certificate" "mydomain" {
  domain = "*."
}

data "aws_route53_zone" "tokyokjdomain" {
  name         = "."
  private_zone = false
}

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.ALB.id,
  ]
  subnets = [
    "${aws_subnet.public1.id}",
    "${aws_subnet.public2.id}",
  ]
  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

resource "aws_lb_listener" "web_alb_listener_https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.mydomain.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}

resource "aws_lb_target_group" "web_alb_tg" {
  name     = "${var.project_name}-${var.environment}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "target_0" {
  target_group_arn = aws_lb_target_group.web_alb_tg.arn
  target_id        = aws_instance.private-ec2.id
  port             = 80
  depends_on = [aws_instance.private-ec2]
}

resource "aws_lb_target_group_attachment" "target_1" {
  target_group_arn = aws_lb_target_group.web_alb_tg.arn
  target_id        = aws_instance.private-ec2-2.id
  port             = 80
  depends_on = [aws_instance.private-ec2-2]
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.tokyokjdomain.zone_id
  name    = "alb."
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}
