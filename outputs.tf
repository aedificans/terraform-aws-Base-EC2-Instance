output "iam_instance_profile" {
  value = var.instance.iam_instance_profile == null ? aws_iam_role.this[0].arn : var.instance.iam_instance_profile
}
output "private_dns" {
  value = aws_instance.this.private_dns
}
output "private_ip" {
  value = aws_instance.this.private_ip
}
output "public_ip" {
  value = var.networking.create_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
}
output "availability_zone" {
  value = aws_instance.this.availability_zone
}
output "keypair_name" {
  value = var.instance.keypair_name == null ? module.key[0].key_name : var.instance.keypair_name
}
output "instance_id" {
  value = aws_instance.this.id
}
output "instance_security_group_id" {
  value = aws_security_group.this.id
}
