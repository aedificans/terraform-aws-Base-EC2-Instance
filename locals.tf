locals {
  ami_windows       = "Windows_Server-2022-English-Full-Base-*"
  ami_linux         = "al2023-ami-2023.*-kernel-6.1-x86_64"
  ami_search_string = var.instance.os == "windows" ? local.ami_windows : local.ami_linux
  # DNS
  create_dns_records = var.networking.public_hosted_zone != null
  public_domain = local.create_dns_records ? (
    var.networking.subdomain == null ? data.aws_route53_zone.public[0].name : "${var.instance.subdomain}.${data.aws_route53_zone.public[0].name}"
  ) : null
  private_domain = local.create_dns_records ? (
    var.networking.subdomain == null ? data.aws_route53_zone.private[0].name : "${var.instance.subdomain}.${data.aws_route53_zone.private[0].name}"
  ) : null
  # Default User Data
  user_data_linux   = base64encode(file("${path.module}/user-data/linux.sh"))
  user_data_windows = base64encode(file("${path.module}/user-data/windows.ps1"))
  default_user_data = var.instance.os == "linux" ? local.user_data_linux : local.user_data_windows
  user_data_base64  = var.instance.user_data_base64 != null ? var.instance.user_data_base64 : local.default_user_data
}
