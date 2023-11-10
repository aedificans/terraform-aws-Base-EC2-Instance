module "key" {
  count = var.instance.keypair_name == null ? 1 : 0

  source  = "app.terraform.io/aedificans/Base-EC2-KeyPair/aws"
  version = "1.0.1"

  environment                                = var.environment
  naming                                     = var.naming
  private_key_kms_arn                        = var.instance.keypair_kms_arn
  private_key_kms_key_rotation_enabled       = var.instance.keypair_kms_key_rotation_enabled
  private_key_secret_recovery_window_in_days = var.instance.keypair_secret_recovery_window_in_days
  tagging                                    = var.tagging
}
