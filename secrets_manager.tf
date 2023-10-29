module "credentials" {
  count = var.instance.get_password_data ? 1 : 0

  source  = "app.terraform.io/aedificans/Base-SecretsManager-Secret/aws"
  version = "1.0.0"

  environment = var.environment
  naming      = var.naming
  description = "The credentials to the ${local.naming.display} Windows EC2 instance"
  kms_key_arn = coalesce(var.instance.keypair_kms_arn, module.key[0].key_arn)
  secret_string = jsonencode(
    {
      username = "Administrator"
      password = rsadecrypt(aws_instance.this.password_data, module.key[0].private_key)
    }
  )
  tagging = var.tagging

  depends_on = [
    module.key
  ]
}
