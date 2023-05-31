resource "aws_route53_zone" "mail" {
  name = var.mail_zone_name
  tags = var.tags
}

resource "aws_route53_record" "mail_record" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = var.mail_zone_name
  type    = "A"
  ttl     = 300
  records = aws_eip.mailserver-eip.public_ip 
}


resource "aws_route53_record" "mail_record_mx" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = "mx_${var.mail_zone_name}"
  type    = "MX"
  ttl     = 300
  records = [var.record_mx]
}


/*
resource "aws_route53_record" "mail_record_dkim" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = "dkim_${var.mail_zone_name}"
  type    = "TXT"
  ttl     = 300
  records = [var.record_dkim]
}
*/

resource "aws_route53_record" "mail_record_spf" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = "spf_${var.mail_zone_name}"
  type    = "TXT"
  ttl     = 300
  records = [ var.record_spf]
}

resource "aws_route53_record" "mail_record_dmark" {
  zone_id = aws_route53_zone.mail.zone_id
  name    = "dmark_${var.mail_zone_name}"
  type    = "TXT"
  ttl     = 300
  records = [var.record_dmark]
}


#conditional creation CNAME records for mailserver2
#https://stackoverflow.com/questions/68221788/terraform-conditional-module-with-dependency