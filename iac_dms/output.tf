output "mailserver_elastic_ip" {
  value = aws_eip.mailserver-eip.public_ip
}

output "mailserver_ip_public_dns" {
  value = aws_eip.mailserver-eip.public_dns
}