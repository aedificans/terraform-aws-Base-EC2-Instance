#==================#
# Naming & Tagging #
#==================#

variable "environment" {
  description = "A naming object for the environment to provide both the environment's name and abbrevation for tagging and reporting purposes"
  type = object({
    name         = string
    abbreviation = string
  })

  validation {
    condition     = can(regex("^[a-zA-Z 0-9\\-]*$", var.environment.name))
    error_message = "The environment name must only contain alphanumeric characters, spaces, and hyphens"
  }
  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.environment.abbreviation))
    error_message = "The environment abbreviation must be kebab case"
  }
}
variable "naming" {
  description = "A naming object to provide the display name of the service from the service catalog, and optionally also a resource name"
  type = object({
    display  = string
    resource = optional(string, null)
  })

  validation {
    condition     = can(regex("^[a-zA-Z 0-9\\-]*$", var.naming.display))
    error_message = "The service display name must only contain alphanumeric characters, spaces, and hyphens"
  }
  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.naming.resource)) || var.naming.resource == null
    error_message = "If provided, the service resource name must be kebab case"
  }
}
variable "tagging" {
  description = "A collection of tags as key-value pairs to be applied to all applicable provisioned resources"
  type = object({
    additional_tags = optional(map(any), {})
    network         = string
    organization    = string
    owner           = string
    service_pattern = string
    tag_key_prefix  = string
  })
}

#====================#
# CloudWatch Configs #
#====================#

variable "cloudwatch" {
  type = object({
    create_log_group      = optional(bool, true)
    log_group_name        = optional(string, null)
    log_retention_in_days = optional(number, 30)
  })
  default     = {}
  description = "An object for passing in CloudWatch configuration options"
}

#==================#
# Instance Configs #
#==================#

variable "instance" {
  description = "An object for passing in all instance configuration options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)"
  type = object({
    additional_iam_policy_arns             = optional(list(string), [])
    ami                                    = optional(string, null)
    aws_backup_enabled                     = optional(bool, false)
    disable_api_termination                = optional(bool, false)
    get_password_data                      = optional(bool, false)
    iam_instance_profile                   = optional(string, null)
    instance_profile_kms_arns              = optional(list(string), [])
    instance_profile_secret_arns           = optional(list(string), [])
    instance_type                          = optional(string, "t3.micro")
    keypair_kms_arn                        = optional(string, null)
    keypair_kms_key_rotation_enabled       = optional(bool, true)
    keypair_name                           = optional(string, null)
    keypair_secret_recovery_window_in_days = optional(number, 0)
    monitoring_enabled                     = optional(bool, true)
    os                                     = optional(string, "linux")
    patch_group                            = optional(string, "manual")
    service_discovery_enabled              = optional(bool, false)
    service_discovery_path                 = optional(string, "/metrics")
    service_discovery_port                 = optional(number, 80)
    user_data_base64                       = optional(string, null)
    user_data_replace_on_change            = optional(bool, false)
  })
  default = {}
  validation {
    condition = anytrue([
      var.instance.os == "windows",
      var.instance.os == "linux"
    ])
    error_message = "must be windows or linux"
  }
}
variable "networking" {
  description = "An object for passing in all instance networking options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)"
  type = object({
    associate_public_ip_address   = optional(bool, false)
    additional_security_group_ids = optional(list(string), [])
    create_eip                    = optional(bool, false)
    egress_cidr_blocks = optional(
      map(object({
        description = optional(string, "Managed by Terraform")
        port        = number
        protocol    = optional(string, "tcp")
        cidr_blocks = list(string)
    })), {})
    egress_security_group_ids = optional(
      map(object({
        description       = optional(string, "Managed by Terraform")
        port              = number
        protocol          = optional(string, "tcp")
        security_group_id = string
    })), {})
    ingress_cidr_blocks = optional(
      map(object({
        description = optional(string, "Managed by Terraform")
        port        = number
        protocol    = optional(string, "tcp")
        cidr_blocks = list(string)
    })), {})
    ingress_security_group_ids = optional(
      map(object({
        description       = optional(string, "Managed by Terraform")
        port              = number
        protocol          = optional(string, "tcp")
        security_group_id = string
    })), {})
    instance_ports      = optional(list(number), [80])
    private_hosted_zone = optional(string, null)
    public_hosted_zone  = optional(string, null)
    subdomain           = optional(string, null)
    subnet_id           = string
    vpc_id              = string
  })
}
variable "volume" {
  description = "An object for passing in all volume configuration options.  For further detail on each, please see the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)"
  type = object({
    delete_on_termination = optional(bool, true)
    ebs_optimized         = optional(bool, false)
    encrypted             = optional(bool, true)
    iops                  = optional(number, 0)
    size                  = optional(number, 20)
    type                  = optional(string, "gp2")
  })
  default = {}
}
