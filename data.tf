data "aws_ami" "default_os_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [local.ami_search_string]
  }

  owners = ["amazon"]
}
data "aws_route53_zone" "public" {
  count = var.networking.public_hosted_zone == null ? 0 : 1

  name         = var.networking.public_hosted_zone
  private_zone = false
}
data "aws_route53_zone" "private" {
  count = var.networking.public_hosted_zone == null ? 0 : 1

  name         = coalesce(var.networking.private_hosted_zone, var.networking.public_hosted_zone)
  private_zone = true
}

#======================#
# IAM Policy Documents #
#======================#

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.instance.instance_profile_kms_arns) > 0 ? [1] : []

    content {
      actions   = ["kms:Decrypt"]
      resources = var.instance.instance_profile_kms_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.instance.instance_profile_secret_arns) > 0 ? [1] : []

    content {
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.instance.instance_profile_secret_arns
    }
  }
}
