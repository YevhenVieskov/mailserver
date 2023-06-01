output "mailserver_elastic_ip" {
  value = aws_eip.mailserver-eip.public_ip
}

output "mailserver_ip_public_dns" {
  value = aws_eip.mailserver-eip.public_dns
}

output "policy_sm_id" {
  description = "The policy ID"
  value       = module.iam_policy_sm.id
}

output "policy_sm_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_policy_sm.arn
}

output "policy_sm_description" {
  description = "The description of the policy"
  value       = module.iam_policy_sm.description
}

output "policy_sm_name" {
  description = "The name of the policy"
  value       = module.iam_policy_sm.name
}

output "policy_route53_id" {
  description = "The policy ID"
  value       = module.iam_policy_route53.id
}

output "policy_route53_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_policy_route53.arn
}

output "policy_route53_description" {
  description = "The description of the policy"
  value       = module.iam_policy_route53.description
}

output "policy_route53_name" {
  description = "The name of the policy"
  value       = module.iam_policy_route53.name
}

output "rotate_secret_arns" {
  description = "Rotate secret arns"
  value       = module.secrets_manager_ansible.rotate_secret_arns
}

output "rotate_secret_ids" {
  description = "Rotate secret ids"
  value       = module.secrets_manager_ansible.rotate_secret_ids
}



