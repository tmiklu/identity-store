# identity-store
This module is for managing IAM Identity Center users and groups

```
locals {
  groups = {
    group1 = {
      display_name = "group1"
      description  = "Description for nameA group1"
    },
    group2 = {
      display_name = "group2"
      description  = "Description for nameB group2"
    }
  }

  users = {
    "user.x" = {
      display_name = "User X"
      email        = "userx@abc.org"
      given_name   = "User"
      family_name  = "X"
      sso_groups   = ["group2"]
      attributes   = {
        phone_numbers = "+1234567890"
      }
    },
    "user.y" = {
      display_name = "User Y"
      email        = "user.y@abc.com"
      given_name   = "User"
      family_name  = "Y"
      sso_groups   = ["group1", "group2"]
      attributes   = {}
    }
  }
}

module "identity-store" {
  source = "git::https://github.com/tmiklu/identity-store.git?ref=v1.0.0"
  groups = local.groups
  users  = local.users
}
```
