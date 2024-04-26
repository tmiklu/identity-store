data "aws_ssoadmin_instances" "this" {}

locals {
  group_membership = flatten([
    for user_name, user_attr in var.users : [
      for group_name in user_attr.sso_groups : {
        user_name  = user_name
        group_name = group_name
      }
    ]
  ])
}

resource "aws_identitystore_user" "this" {
  for_each          = { for key, user_details in var.users : key => user_details }
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.value["display_name"]
  user_name         = each.value["email"]
  
  dynamic "phone_numbers" {
    for_each = can(each.value["attributes"]["phone_numbers"]) ? [1] : []
    content {
      primary = true
      type = "mobile"
      value = each.value["attributes"]["phone_numbers"]
    }
  }

  name {
    family_name = each.value["family_name"]
    given_name  = each.value["given_name"]
  }
}

resource "aws_identitystore_group" "this" {
  for_each          = { for key, group_details in var.groups : key => group_details }
  display_name      = each.value["display_name"]
  description       = each.value["description"]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_group_membership" "this" {
  for_each = { for pair in local.group_membership : "${pair.user_name}.${pair.group_name}" => pair }
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this[each.value.group_name].group_id
  member_id         = aws_identitystore_user.this[each.value.user_name].user_id
}
