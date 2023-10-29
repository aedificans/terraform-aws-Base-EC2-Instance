resource "aws_instance" "this" {
  ami                         = coalesce(var.instance.ami, data.aws_ami.default_os_ami.id)
  associate_public_ip_address = var.networking.associate_public_ip_address
  disable_api_termination     = var.instance.disable_api_termination
  ebs_optimized               = var.volume.ebs_optimized
  get_password_data           = var.instance.get_password_data
  iam_instance_profile        = coalesce(var.instance.iam_instance_profile, aws_iam_instance_profile.this[0].name)
  instance_type               = var.instance.instance_type
  key_name                    = coalesce(var.instance.keypair_name, module.key[0].key_name)
  monitoring                  = var.instance.monitoring_enabled
  user_data_base64            = local.user_data_base64
  user_data_replace_on_change = var.instance.user_data_replace_on_change
  subnet_id                   = var.networking.subnet_id
  vpc_security_group_ids = concat(
    [aws_security_group.this.id],
    tolist(var.networking.additional_security_group_ids)
  )

  root_block_device {
    encrypted   = var.volume.encrypted
    volume_size = var.volume.size
  }

  tags = merge(
    local.tags,
    local.backup_tags,
    local.service_discovery_tags,
    tomap({
      "Name"                                         = "${local.naming.display} Instance",
      "${var.tagging.tag_key_prefix}:patching:group" = var.instance.patch_group
    })
  )

  volume_tags = merge(
    local.tags,
    local.backup_tags,
    tomap({ "Name" = "${local.naming.display} Volume" })
  )

  lifecycle {
    ignore_changes = [
      ami,
      user_data_base64,
    ]
  }
}
