I apologize, it seems that I made a mistake on my previous response. The `metadata_options` block is not available for the `aws_instance` resource and the `http_token` is not an available option. The security vulnerability that you mentioned, "Instance does not require IMDS access to require a token" is related to the Instance Metadata Service (IMDS) that is available on all Amazon EC2 instances. This service provides information about the instance, such as the hostname, IAM role and security credentials, and IP addresses.

To address this vulnerability, you will have to implement the following:
- Use a firewall to block access to the IMDS endpoint (169.254.169.254)
- Use the IAM Role and Instance Profile to limit access to the IMDS
- Use the EC2 Parameter Store to store and retrieve the credentials
- Use IAM Roles for Service Accounts to allow different applications to access different resources
- Limit the permissions of the IAM Role associated with the instance

You can also read more about the security best practices for IMDS at the following links:
- https://aws.amazon.com/blogs/security/how-to-control-access-to-your-instance-metadata-service-imds-in-aws/
- https://aws.amazon.com/premiumsupport/knowledge-center/iam-role-ec2-instance-metadata/

Please let me know if you have any other questions.
