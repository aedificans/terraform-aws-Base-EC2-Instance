resource "aws_route53_record" "public" {
  count = local.create_dns_records ? 1 : 0

  zone_id = data.aws_route53_zone.public[0].zone_id
  name    = local.public_domain
  type    = "A"
  ttl     = 300
  records = [var.networking.create_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip]
}
resource "aws_route53_record" "private" {
  count = local.create_dns_records ? 1 : 0

  zone_id = data.aws_route53_zone.private[0].zone_id
  name    = local.private_domain
  type    = "A"
  ttl     = 300
  records = [aws_instance.this.private_ip]
}
