resource "aws_iam_role" "this" {
  count = var.instance.iam_instance_profile == null ? 1 : 0

  name               = "${local.naming.iam}Instance"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} Instance Role" })
  )
}
resource "aws_iam_instance_profile" "this" {
  count = var.instance.iam_instance_profile == null ? 1 : 0

  name = local.naming.iam
  role = aws_iam_role.this[0].name

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} Instance Profile" })
  )
}
resource "aws_iam_policy" "this" {
  count = var.instance.iam_instance_profile == null ? 1 : 0

  name   = "${local.naming.iam}Access"
  policy = data.aws_iam_policy_document.this.json

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} Access" })
  )
}
resource "aws_iam_role_policy_attachment" "this" {
  count = var.instance.iam_instance_profile == null ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}
resource "aws_iam_role_policy_attachment" "additional_policies" {
  for_each = toset(var.instance.additional_iam_policy_arns)

  role       = aws_iam_role.this[0].name
  policy_arn = each.key
}
