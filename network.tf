#============#
# Elastic IP #
#============#

resource "aws_eip" "this" {
  count = var.networking.create_eip ? 1 : 0

  instance = aws_instance.this.id
  domain   = "vpc"
}
resource "aws_eip_association" "this" {
  count = var.networking.create_eip ? 1 : 0

  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}

#================#
# Security Group #
#================#

resource "aws_security_group" "this" {
  name        = local.naming.resource
  description = "Security Group for ${var.naming.display} in ${var.environment.name} ${var.tagging.network} network"
  vpc_id      = var.networking.vpc_id

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} Security Group" })
  )
}
resource "aws_vpc_security_group_ingress_rule" "cidr_blocks" {
  for_each = {
    for ingress in flatten([
      for ingress_name, cidr_block_config in var.networking.ingress_cidr_blocks : [
        for cidr_block in cidr_block_config.cidr_blocks : {
          description = cidr_block_config.description
          port        = cidr_block_config.port
          protocol    = cidr_block_config.protocol
          cidr_blocks = cidr_block
        }
      ]
    ]) : "${ingress.description} ${ingress.cidr_block}" => ingress
  }

  description       = each.value.description
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_block
  security_group_id = aws_security_group.this.id
}
resource "aws_vpc_security_group_ingress_rule" "security_group_ids" {
  for_each = var.networking.ingress_security_group_ids

  description                  = each.value.description
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.security_group_id
  security_group_id            = aws_security_group.this.id
}
resource "aws_vpc_security_group_egress_rule" "cidr_blocks" {
  for_each = {
    for egress in flatten([
      for egress_name, cidr_block_config in var.networking.egress_cidr_blocks : [
        for cidr_block in cidr_block_config.cidr_blocks : {
          description = cidr_block_config.description
          port        = cidr_block_config.port
          protocol    = cidr_block_config.protocol
          cidr_block  = cidr_block
        }
      ]
    ]) : "${egress.description} ${egress.cidr_block}" => egress
  }

  description       = each.value.description
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_block
  security_group_id = aws_security_group.this.id
}
resource "aws_vpc_security_group_egress_rule" "security_group_ids" {
  for_each = var.networking.egress_security_group_ids

  description                  = each.value.description
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.security_group_id
  security_group_id            = aws_security_group.this.id
}
