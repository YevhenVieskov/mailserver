{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
               "route53:ChangeResourceRecordSets",
               "route53:CreateTrafficPolicy",
               "route53:DeleteTrafficPolicy",
               "route53:CreateTrafficPolicyInstance",
               "route53:CreateTrafficPolicyVersion",
               "route53:UpdateTrafficPolicyInstance",
               "route53:UpdateTrafficPolicyComment",
               "route53:DeleteTrafficPolicyInstance",
               "route53:CreateHealthCheck",
               "route53:UpdateHealthCheck",
               "route53:DeleteHealthCheck",
               "route53:List*",
               "route53:Get*"
            ],

            "Resource": [
                "*"
            ]            
        }
    ]
}