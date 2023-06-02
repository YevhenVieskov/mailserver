resource "aws_route53_zone" "mail" {
  name = var.mail_zone_name
  tags = var.tags
}

resource "aws_route53_record" "mail_record" {
  zone_id         = aws_route53_zone.mail.zone_id
  name            = var.mail_zone_name
  type            = "A"
  ttl             = 300
  records         = [aws_eip.mailserver-eip.public_ip]
  allow_overwrite = true
}


resource "aws_route53_record" "mail_record_mx" {
  zone_id         = aws_route53_zone.mail.zone_id
  name            = ""
  type            = "MX"
  ttl             = 300
  records         = [var.record_mx]
  allow_overwrite = true
}


/*
resource "aws_route53_record" "mail_record_dkim" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = "protonmail._domainkey"
  type    = "TXT"
  ttl     = 300
  records = [var.record_dkim]
}
*/

resource "aws_route53_record" "mail_record_spf" {
  zone_id         = aws_route53_zone.mail.zone_id
  name            = ""
  type            = "TXT"
  ttl             = 300
  records         = [var.record_spf]
  allow_overwrite = true
}

resource "aws_route53_record" "mail_record_dmark" {
  zone_id         = aws_route53_zone.mail.zone_id
  name            = "_dmark.${var.mail_zone_name}"
  type            = "TXT"
  ttl             = 300
  records         = [var.record_dmark]
  allow_overwrite = true
}

resource "aws_route53_record" "mail_record_www" {
  count   = var.mailserver2 ? 1 : 0
  zone_id = aws_route53_zone.mail.zone_id
  name    = "www"
  type    = "CNAME"
  records = [var.mail_zone_name]
  ttl     = 300
}

resource "aws_route53_record" "mail_record_postfixadmin" {
  count   = var.mailserver2 ? 1 : 0
  zone_id = aws_route53_zone.mail.zone_id
  name    = "postfixadmin"
  type    = "CNAME"
  records = [var.mail_zone_name]
  ttl     = 300
}

resource "aws_route53_record" "mail_record_webmail" {
  count   = var.mailserver2 ? 1 : 0
  zone_id = aws_route53_zone.mail.zone_id
  name    = "webmail"
  type    = "CNAME"
  records = [var.mail_zone_name]
  ttl     = 300
}

resource "aws_route53_record" "mail_record_spam" {
  count   = var.mailserver2 ? 1 : 0
  zone_id = aws_route53_zone.mail.zone_id
  name    = "spam"
  type    = "CNAME"
  records = [var.mail_zone_name]
  ttl     = 300
}



#conditional creation CNAME records for mailserver2
#https://stackoverflow.com/questions/68221788/terraform-conditional-module-with-dependency