# EC2: Instance

Terraform module which creates an EC2 instance and other resources required for it

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_credentials"></a> [credentials](#module\_credentials) | app.terraform.io/aedificans/Base-SecretsManager-Secret/aws | 1.0.0 |
| <a name="module_key"></a> [key](#module\_key) | app.terraform.io/aedificans/Base-EC2-KeyPair/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.security_group_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.security_group_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.default_os_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch"></a> [cloudwatch](#input\_cloudwatch) | An object for passing in CloudWatch configuration options | <pre>object({<br>    create_log_group      = optional(bool, true)<br>    log_group_name        = optional(string, null)<br>    log_retention_in_days = optional(number, 30)<br>  })</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | A naming object for the environment to provide both the environment's name and abbrevation for tagging and reporting purposes | <pre>object({<br>    name         = string<br>    abbreviation = string<br>  })</pre> | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | An object for passing in all instance configuration options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | <pre>object({<br>    additional_iam_policy_arns             = optional(list(string), [])<br>    ami                                    = optional(string, null)<br>    aws_backup_enabled                     = optional(bool, false)<br>    disable_api_termination                = optional(bool, false)<br>    get_password_data                      = optional(bool, false)<br>    iam_instance_profile                   = optional(string, null)<br>    instance_profile_kms_arns              = optional(list(string), [])<br>    instance_profile_secret_arns           = optional(list(string), [])<br>    instance_type                          = optional(string, "t3.micro")<br>    keypair_kms_arn                        = optional(string, null)<br>    keypair_kms_key_rotation_enabled       = optional(bool, true)<br>    keypair_name                           = optional(string, null)<br>    keypair_secret_recovery_window_in_days = optional(number, 0)<br>    monitoring_enabled                     = optional(bool, true)<br>    os                                     = optional(string, "linux")<br>    patch_group                            = optional(string, "manual")<br>    service_discovery_enabled              = optional(bool, false)<br>    service_discovery_path                 = optional(string, "/metrics")<br>    service_discovery_port                 = optional(number, 80)<br>    user_data_base64                       = optional(string, null)<br>    user_data_replace_on_change            = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | A naming object to provide the display name of the service from the service catalog, and optionally also a resource name | <pre>object({<br>    display  = string<br>    resource = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_networking"></a> [networking](#input\_networking) | An object for passing in all instance networking options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | <pre>object({<br>    associate_public_ip_address   = optional(bool, false)<br>    additional_security_group_ids = optional(list(string), [])<br>    create_eip                    = optional(bool, false)<br>    egress_cidr_blocks = optional(<br>      map(object({<br>        description = optional(string, "Managed by Terraform")<br>        port        = number<br>        protocol    = optional(string, "tcp")<br>        cidr_blocks = list(string)<br>    })), {})<br>    egress_security_group_ids = optional(<br>      map(object({<br>        description       = optional(string, "Managed by Terraform")<br>        port              = number<br>        protocol          = optional(string, "tcp")<br>        security_group_id = string<br>    })), {})<br>    ingress_cidr_blocks = optional(<br>      map(object({<br>        description = optional(string, "Managed by Terraform")<br>        port        = number<br>        protocol    = optional(string, "tcp")<br>        cidr_blocks = list(string)<br>    })), {})<br>    ingress_security_group_ids = optional(<br>      map(object({<br>        description       = optional(string, "Managed by Terraform")<br>        port              = number<br>        protocol          = optional(string, "tcp")<br>        security_group_id = string<br>    })), {})<br>    instance_ports      = optional(list(number), [80])<br>    private_hosted_zone = optional(string, null)<br>    public_hosted_zone  = optional(string, null)<br>    subdomain           = optional(string, null)<br>    subnet_id           = string<br>    vpc_id              = string<br>  })</pre> | n/a | yes |
| <a name="input_tagging"></a> [tagging](#input\_tagging) | A collection of tags as key-value pairs to be applied to all applicable provisioned resources | <pre>object({<br>    additional_tags = optional(map(any), {})<br>    network         = string<br>    organization    = string<br>    owner           = string<br>    service_pattern = string<br>    tag_key_prefix  = string<br>  })</pre> | n/a | yes |
| <a name="input_volume"></a> [volume](#input\_volume) | An object for passing in all volume configuration options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | <pre>object({<br>    delete_on_termination = optional(bool, true)<br>    ebs_optimized         = optional(bool, false)<br>    encrypted             = optional(bool, true)<br>    iops                  = optional(number, 0)<br>    size                  = optional(number, 20)<br>    type                  = optional(string, "gp2")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | n/a |
| <a name="output_iam_instance_profile"></a> [iam\_instance\_profile](#output\_iam\_instance\_profile) | n/a |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_instance_security_group_id"></a> [instance\_security\_group\_id](#output\_instance\_security\_group\_id) | n/a |
| <a name="output_keypair_name"></a> [keypair\_name](#output\_keypair\_name) | n/a |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | n/a |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->
