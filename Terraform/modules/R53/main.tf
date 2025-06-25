data "aws_route53_zone" "threat-compose-zone" {
  name         = "sehindemitech.co.uk"
  private_zone = false
}
resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.threat-compose-zone.zone_id
  name    = "app.sehindemitech.co.uk"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "app.sehindemitech.co.uk"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for i in aws_acm_certificate.alb_cert.domain_validation_options :
    i.domain_name => {
      name   = i.resource_record_name
      record = i.resource_record_value
      type   = i.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.threat-compose-zone.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = 300
}



resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}

