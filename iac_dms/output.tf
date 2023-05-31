output "mailserver_elastic_ip" {
  value = aws_eip.mailserver-eip.public_ip
}

output "mailserver_ip_public_dns" {
  value = aws_eip.mailserver-eip.public_dns
}

output "policy_sm_id" {
  description = "The policy ID"
  value       = module.iam_policy.id
}

output "policy_sm_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_policy.arn
}

output "policy_sm_description" {
  description = "The description of the policy"
  value       = module.iam_policy.description
}

output "policy_sm_name" {
  description = "The name of the policy"
  value       = module.iam_policy.name
}

output "policy_route53_id" {
  description = "The policy ID"
  value       = module.iam_policy.id
}

output "policy_route53_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_policy.arn
}

output "policy_route53_description" {
  description = "The description of the policy"
  value       = module.iam_policy.description
}

output "policy_route53_name" {
  description = "The name of the policy"
  value       = module.iam_policy.name
}

output "rotate_secret_arns" {
  description = "Rotate secret arns map"
  value       = module.secrets_manager_ansible.rotate_secret_arns
}

output "rotate_secret_arns" {
  description = "Rotate secret arns map"
  value       = module.secrets_manager_ansible.rotate_secret_arns
}

output "rotate_secret_arns" {
  description = "Rotate secret arns map"
  value       = module.secrets_manager_ansible.rotate_secret_arns
}


rotate_secret_ids 	Rotate secret ids map
secret_arns 	Secrets arns map
secret_ids 	Secret ids map